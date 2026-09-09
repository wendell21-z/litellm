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
    var providerKeys: [ProviderKind: String]

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
        self.configuration = configService.loadConfiguration()
        let keychainService = KeychainService()
        self.localProxyKey = keychainService.read(account: "LITELLM_MASTER_KEY")
        self.providerKeys = Dictionary(
            uniqueKeysWithValues: ProviderKind.allCases.map { ($0, keychainService.read(account: $0.environmentKey)) }
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
            provider: .openAI,
            litellmModel: "openai/gpt-5-mini"
        )
        configuration.models.append(model)
        configuration.activeModelID = model.id
        saveConfiguration()
    }

    func removeActiveModel() {
        guard configuration.models.count > 1 else {
            return
        }
        configuration.models.removeAll { $0.id == configuration.activeModelID }
        if let first = configuration.models.first {
            configuration.activeModelID = first.id
        }
        saveConfiguration()
    }

    func bindingForActiveModel<Value>(_ keyPath: WritableKeyPath<ProviderModel, Value>) -> Binding<Value>? {
        guard let index = configuration.models.firstIndex(where: { $0.id == configuration.activeModelID }) else {
            return nil
        }
        return Binding {
            self.configuration.models[index][keyPath: keyPath]
        } set: { value in
            self.configuration.models[index][keyPath: keyPath] = value
            self.saveConfiguration()
        }
    }

    func saveProviderKey(_ value: String, provider: ProviderKind) {
        providerKeys[provider] = value
        try? keychain.save(value, account: provider.environmentKey)
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
        let providerEnvironment = Dictionary(
            uniqueKeysWithValues: providerKeys.map { ($0.key.environmentKey, $0.value) }
        )
        return providerEnvironment.merging(["LITELLM_MASTER_KEY": localProxyKey]) { _, new in new }
    }
}
