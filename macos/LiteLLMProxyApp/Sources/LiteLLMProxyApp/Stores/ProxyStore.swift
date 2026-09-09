import Foundation
import Observation
import SwiftUI

@Observable
@MainActor
final class ProxyStore {
    var configuration: ProxyConfiguration
    var status: ProxyStatus = .stopped
    var discoveredModels: [String] = []
    var localProxyKey: String
    var credentialSecrets: [UUID: String]

    private let configService: LiteLLMConfigService
    private let processService: LiteLLMProcessService
    private let healthClient: LiteLLMHealthClient
    private let keychain = KeychainService()

    init(
        configService: LiteLLMConfigService,
        processService: LiteLLMProcessService,
        healthClient: LiteLLMHealthClient
    ) {
        self.configService = configService
        self.processService = processService
        self.healthClient = healthClient
        let loadedConfiguration = configService.loadConfiguration()
        self.configuration = loadedConfiguration
        let keychainService = KeychainService()
        self.localProxyKey = keychainService.read(account: "LITELLM_MASTER_KEY")
        self.credentialSecrets = Dictionary(
            uniqueKeysWithValues: loadedConfiguration.credentials.map { ($0.id, keychainService.read(account: $0.id.uuidString)) }
        )

        if localProxyKey.isEmpty {
            localProxyKey = "sk-local-\(UUID().uuidString.replacingOccurrences(of: "-", with: ""))"
            try? keychainService.save(localProxyKey, account: "LITELLM_MASTER_KEY")
        }
    }

    var activeModel: ProviderModel? {
        configuration.models.first { $0.id == configuration.activeModelID }
    }

    var baseURL: String {
        "http://127.0.0.1:\(configuration.port)/v1"
    }

    func selectModel(_ model: ProviderModel) {
        configuration.activeModelID = model.id
        saveConfiguration()
    }

    func addModel() {
        let model = ProviderModel(
            displayName: "New Model",
            providerID: "openai",
            litellmModel: "openai/gpt-5-mini",
            credentialID: configuration.credentials.first { $0.providerID == "openai" }?.id
        )
        configuration.models.append(model)
        configuration.activeModelID = model.id
        saveConfiguration()
    }

    func addCredential() {
        let credential = CredentialRecord(
            displayName: "New Credential",
            providerID: "openai",
            environmentKey: ProviderDescriptor.defaultEnvironmentKey(for: "openai")
        )
        configuration.credentials.append(credential)
        credentialSecrets[credential.id] = ""
        saveConfiguration()
    }

    func removeCredential(id: UUID) {
        configuration.credentials.removeAll { $0.id == id }
        credentialSecrets[id] = nil
        configuration.models = configuration.models.map { model in
            ProviderModel(
                id: model.id,
                displayName: model.displayName,
                providerID: model.providerID,
                litellmModel: model.litellmModel,
                credentialID: model.credentialID == id ? nil : model.credentialID,
                isEnabled: model.isEnabled
            )
        }
        saveConfiguration()
    }

    func removeModel(id: UUID) {
        guard configuration.models.count > 1 else {
            return
        }
        configuration.models.removeAll { $0.id == id }
        if configuration.activeModelID == id, let first = configuration.models.first {
            configuration.activeModelID = first.id
        }
        saveConfiguration()
    }

    func removeActiveModel() {
        removeModel(id: configuration.activeModelID)
    }

    func bindingForActiveModel<Value>(_ keyPath: WritableKeyPath<ProviderModel, Value>) -> Binding<Value>? {
        bindingForModel(id: configuration.activeModelID, keyPath)
    }

    func bindingForModel<Value>(id: UUID, _ keyPath: WritableKeyPath<ProviderModel, Value>) -> Binding<Value>? {
        guard let index = configuration.models.firstIndex(where: { $0.id == id }) else {
            return nil
        }
        return Binding {
            self.configuration.models[index][keyPath: keyPath]
        } set: { value in
            self.configuration.models[index][keyPath: keyPath] = value
            self.saveConfiguration()
        }
    }

    func bindingForCredential<Value>(id: UUID, _ keyPath: WritableKeyPath<CredentialRecord, Value>) -> Binding<Value>? {
        guard let index = configuration.credentials.firstIndex(where: { $0.id == id }) else {
            return nil
        }
        return Binding {
            self.configuration.credentials[index][keyPath: keyPath]
        } set: { value in
            self.configuration.credentials[index][keyPath: keyPath] = value
            self.saveConfiguration()
        }
    }

    func saveCredentialSecret(_ value: String, credentialID: UUID) {
        credentialSecrets[credentialID] = value
        try? keychain.save(value, account: credentialID.uuidString)
    }

    func saveConfiguration() {
        do {
            try configService.saveConfiguration(configuration)
        } catch {
            status = .failed(error.localizedDescription)
        }
    }

    func startProxy() async {
        status = .starting
        saveConfiguration()

        do {
            let environment = environmentForProxy()
            try processService.start(
                configURL: try configService.configurationURL(),
                port: configuration.port,
                environment: environment
            )
            try await Task.sleep(for: .seconds(1))
            await refreshHealth()
        } catch {
            status = .failed(error.localizedDescription)
        }
    }

    func restartProxy() async {
        stopProxy()
        await startProxy()
    }

    func stopProxy() {
        processService.stop()
        status = .stopped
        discoveredModels = []
    }

    func refreshHealth() async {
        do {
            discoveredModels = try await healthClient.models(port: configuration.port, localKey: localProxyKey)
            status = .running
        } catch {
            status = processService.isRunning ? .failed("Proxy started, but health check failed") : .stopped
        }
    }

    private func environmentForProxy() -> [String: String] {
        let credentialEnvironment = configuration.credentials.reduce(into: [String: String]()) { environment, credential in
            environment[credential.environmentKey] = credentialSecrets[credential.id] ?? ""
        }
        return credentialEnvironment.merging(["LITELLM_MASTER_KEY": localProxyKey]) { _, new in new }
    }
}
