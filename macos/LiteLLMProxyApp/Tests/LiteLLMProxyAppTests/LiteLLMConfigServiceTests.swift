import Foundation
import Testing
@testable import LiteLLMProxyApp

struct LiteLLMConfigServiceTests {
    @Test
    func renderedConfigKeepsStablePublicModelName() {
        let model = ProviderModel(
            id: UUID(uuidString: "00000000-0000-0000-0000-000000000001")!,
            displayName: "Claude",
            providerID: "anthropic",
            litellmModel: "anthropic/claude-sonnet-4-5",
            credentialID: UUID(uuidString: "00000000-0000-0000-0000-000000000002")!
        )
        let credential = CredentialRecord(
            id: UUID(uuidString: "00000000-0000-0000-0000-000000000002")!,
            displayName: "Anthropic",
            providerID: "anthropic",
            environmentKey: "ANTHROPIC_API_KEY"
        )
        let configuration = ProxyConfiguration(
            publicModelName: "current",
            port: 4000,
            activeModelID: model.id,
            models: [model],
            credentials: [credential]
        )

        let yaml = LiteLLMConfigService().renderLiteLLMConfig(configuration)

        #expect(yaml.contains("model_name: current"))
        #expect(yaml.contains("model: anthropic/claude-sonnet-4-5"))
        #expect(yaml.contains("api_key: os.environ/ANTHROPIC_API_KEY"))
        #expect(yaml.contains("master_key: os.environ/LITELLM_MASTER_KEY"))
    }
}
