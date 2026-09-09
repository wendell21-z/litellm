import Foundation

enum ProviderKind: String, CaseIterable, Codable, Identifiable {
    case openAI = "openai"
    case anthropic
    case gemini
    case openRouter = "openrouter"
    case bedrock

    var id: String { rawValue }

    var title: String {
        switch self {
        case .openAI: "OpenAI"
        case .anthropic: "Anthropic"
        case .gemini: "Gemini"
        case .openRouter: "OpenRouter"
        case .bedrock: "AWS Bedrock"
        }
    }

    var environmentKey: String {
        switch self {
        case .openAI: "OPENAI_API_KEY"
        case .anthropic: "ANTHROPIC_API_KEY"
        case .gemini: "GEMINI_API_KEY"
        case .openRouter: "OPENROUTER_API_KEY"
        case .bedrock: "AWS_ACCESS_KEY_ID"
        }
    }
}

struct ProviderModel: Identifiable, Hashable, Codable {
    var id: UUID
    var displayName: String
    var provider: ProviderKind
    var litellmModel: String
    var isEnabled: Bool

    init(id: UUID = UUID(), displayName: String, provider: ProviderKind, litellmModel: String, isEnabled: Bool = true) {
        self.id = id
        self.displayName = displayName
        self.provider = provider
        self.litellmModel = litellmModel
        self.isEnabled = isEnabled
    }
}

struct ProxyConfiguration: Codable, Equatable {
    var publicModelName: String
    var port: Int
    var activeModelID: UUID
    var models: [ProviderModel]

    static var initial: ProxyConfiguration {
        let models = [
            ProviderModel(displayName: "GPT-5 mini", provider: .openAI, litellmModel: "openai/gpt-5-mini"),
            ProviderModel(displayName: "Claude", provider: .anthropic, litellmModel: "anthropic/claude-sonnet-4-5"),
            ProviderModel(displayName: "Gemini", provider: .gemini, litellmModel: "gemini/gemini-2.5-pro")
        ]
        return ProxyConfiguration(publicModelName: "current", port: 4000, activeModelID: models[0].id, models: models)
    }
}

enum ProxyStatus: Equatable {
    case stopped
    case starting
    case running
    case failed(String)

    var title: String {
        switch self {
        case .stopped: "Stopped"
        case .starting: "Starting"
        case .running: "Running"
        case .failed: "Failed"
        }
    }
}
