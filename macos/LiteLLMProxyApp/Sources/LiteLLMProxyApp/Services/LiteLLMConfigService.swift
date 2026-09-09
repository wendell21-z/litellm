import Foundation

struct LiteLLMConfigService {
    private let fileManager = FileManager.default

    var appSupportDirectory: URL {
        get throws {
            let base = try fileManager.url(
                for: .applicationSupportDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true
            )
            let directory = base.appending(path: "LiteLLMProxyApp", directoryHint: .isDirectory)
            try fileManager.createDirectory(at: directory, withIntermediateDirectories: true)
            return directory
        }
    }

    func configurationURL() throws -> URL {
        try appSupportDirectory.appending(path: "config.yaml")
    }

    func stateURL() throws -> URL {
        try appSupportDirectory.appending(path: "state.json")
    }

    func loadConfiguration() -> ProxyConfiguration {
        guard let url = try? stateURL(),
              let data = try? Data(contentsOf: url),
              let configuration = try? JSONDecoder().decode(ProxyConfiguration.self, from: data)
        else {
            return .initial
        }
        return configuration
    }

    func saveConfiguration(_ configuration: ProxyConfiguration) throws {
        let data = try JSONEncoder.sorted.encode(configuration)
        try data.write(to: try stateURL(), options: .atomic)
        try renderLiteLLMConfig(configuration).write(to: try configurationURL(), atomically: true, encoding: .utf8)
    }

    func renderLiteLLMConfig(_ configuration: ProxyConfiguration) -> String {
        guard let active = configuration.models.first(where: { $0.id == configuration.activeModelID }) else {
            return ""
        }
        let credential = configuration.credentials.first { $0.id == active.credentialID }
        let environmentKey = credential?.environmentKey ?? ProviderDescriptor.defaultEnvironmentKey(for: active.providerID)

        return """
        model_list:
          - model_name: \(configuration.publicModelName)
            litellm_params:
              model: \(active.litellmModel)
              api_key: os.environ/\(environmentKey)

        general_settings:
          master_key: os.environ/LITELLM_MASTER_KEY
          disable_spend_logs: true

        litellm_settings:
          drop_params: true
          set_verbose: false
        """
    }
}
