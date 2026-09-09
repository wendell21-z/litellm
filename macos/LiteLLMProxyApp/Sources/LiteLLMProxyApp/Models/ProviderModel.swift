import Foundation

struct ProviderDescriptor: Identifiable, Hashable {
    let id: String
    let title: String
    let defaultEnvironmentKey: String

    static let catalog: [ProviderDescriptor] = [
        .init(id: "openai", title: "OpenAI", defaultEnvironmentKey: "OPENAI_API_KEY"),
        .init(id: "anthropic", title: "Anthropic", defaultEnvironmentKey: "ANTHROPIC_API_KEY"),
        .init(id: "gemini", title: "Gemini", defaultEnvironmentKey: "GEMINI_API_KEY"),
        .init(id: "openrouter", title: "OpenRouter", defaultEnvironmentKey: "OPENROUTER_API_KEY"),
        .init(id: "azure", title: "Azure OpenAI", defaultEnvironmentKey: "AZURE_API_KEY"),
        .init(id: "bedrock", title: "AWS Bedrock", defaultEnvironmentKey: "AWS_ACCESS_KEY_ID"),
        .init(id: "vertex_ai", title: "Vertex AI", defaultEnvironmentKey: "GOOGLE_APPLICATION_CREDENTIALS"),
        .init(id: "cohere", title: "Cohere", defaultEnvironmentKey: "COHERE_API_KEY"),
        .init(id: "mistral", title: "Mistral", defaultEnvironmentKey: "MISTRAL_API_KEY"),
        .init(id: "groq", title: "Groq", defaultEnvironmentKey: "GROQ_API_KEY"),
        .init(id: "xai", title: "xAI", defaultEnvironmentKey: "XAI_API_KEY"),
        .init(id: "deepseek", title: "DeepSeek", defaultEnvironmentKey: "DEEPSEEK_API_KEY"),
        .init(id: "perplexity", title: "Perplexity", defaultEnvironmentKey: "PERPLEXITYAI_API_KEY"),
        .init(id: "together_ai", title: "Together AI", defaultEnvironmentKey: "TOGETHERAI_API_KEY"),
        .init(id: "fireworks_ai", title: "Fireworks AI", defaultEnvironmentKey: "FIREWORKS_AI_API_KEY"),
        .init(id: "deepinfra", title: "DeepInfra", defaultEnvironmentKey: "DEEPINFRA_API_KEY"),
        .init(id: "replicate", title: "Replicate", defaultEnvironmentKey: "REPLICATE_API_KEY"),
        .init(id: "huggingface", title: "Hugging Face", defaultEnvironmentKey: "HUGGINGFACE_API_KEY"),
        .init(id: "ollama", title: "Ollama", defaultEnvironmentKey: "OLLAMA_API_KEY"),
        .init(id: "vllm", title: "vLLM", defaultEnvironmentKey: "VLLM_API_KEY"),
        .init(id: "lm_studio", title: "LM Studio", defaultEnvironmentKey: "LM_STUDIO_API_KEY"),
        .init(id: "databricks", title: "Databricks", defaultEnvironmentKey: "DATABRICKS_API_KEY"),
        .init(id: "watsonx", title: "Watsonx", defaultEnvironmentKey: "WATSONX_API_KEY"),
        .init(id: "dashscope", title: "DashScope", defaultEnvironmentKey: "DASHSCOPE_API_KEY"),
        .init(id: "moonshot", title: "Moonshot", defaultEnvironmentKey: "MOONSHOT_API_KEY"),
        .init(id: "sambanova", title: "SambaNova", defaultEnvironmentKey: "SAMBANOVA_API_KEY"),
        .init(id: "nvidia_nim", title: "NVIDIA NIM", defaultEnvironmentKey: "NVIDIA_NIM_API_KEY"),
        .init(id: "cerebras", title: "Cerebras", defaultEnvironmentKey: "CEREBRAS_API_KEY"),
        .init(id: "github", title: "GitHub Models", defaultEnvironmentKey: "GITHUB_API_KEY"),
        .init(id: "custom_openai", title: "Custom OpenAI", defaultEnvironmentKey: "CUSTOM_OPENAI_API_KEY"),
        .init(id: "chatgpt", title: "ChatGPT", defaultEnvironmentKey: "CHATGPT_API_KEY"),
        .init(id: "openai_like", title: "OpenAI Like", defaultEnvironmentKey: "OPENAI_LIKE_API_KEY"),
        .init(id: "jina_ai", title: "Jina AI", defaultEnvironmentKey: "JINA_AI_API_KEY"),
        .init(id: "zai", title: "Z.ai", defaultEnvironmentKey: "ZAI_API_KEY"),
        .init(id: "text-completion-openai", title: "OpenAI Text Completion", defaultEnvironmentKey: "OPENAI_API_KEY"),
        .init(id: "cohere_chat", title: "Cohere Chat", defaultEnvironmentKey: "COHERE_API_KEY"),
        .init(id: "clarifai", title: "Clarifai", defaultEnvironmentKey: "CLARIFAI_API_KEY"),
        .init(id: "anthropic_text", title: "Anthropic Text", defaultEnvironmentKey: "ANTHROPIC_API_KEY"),
        .init(id: "bytez", title: "Bytez", defaultEnvironmentKey: "BYTEZ_API_KEY"),
        .init(id: "reducto", title: "Reducto", defaultEnvironmentKey: "REDUCTO_API_KEY"),
        .init(id: "runwayml", title: "RunwayML", defaultEnvironmentKey: "RUNWAYML_API_KEY"),
        .init(id: "aws_polly", title: "AWS Polly", defaultEnvironmentKey: "AWS_ACCESS_KEY_ID"),
        .init(id: "datarobot", title: "DataRobot", defaultEnvironmentKey: "DATAROBOT_API_KEY"),
        .init(id: "vertex_ai_beta", title: "Vertex AI Beta", defaultEnvironmentKey: "GOOGLE_APPLICATION_CREDENTIALS"),
        .init(id: "ai21", title: "AI21", defaultEnvironmentKey: "AI21_API_KEY"),
        .init(id: "ai21_chat", title: "AI21 Chat", defaultEnvironmentKey: "AI21_API_KEY"),
        .init(id: "baseten", title: "Baseten", defaultEnvironmentKey: "BASETEN_API_KEY"),
        .init(id: "black_forest_labs", title: "Black Forest Labs", defaultEnvironmentKey: "BFL_API_KEY"),
        .init(id: "azure_text", title: "Azure Text", defaultEnvironmentKey: "AZURE_API_KEY"),
        .init(id: "azure_ai", title: "Azure AI", defaultEnvironmentKey: "AZURE_AI_API_KEY"),
        .init(id: "sagemaker", title: "SageMaker", defaultEnvironmentKey: "AWS_ACCESS_KEY_ID"),
        .init(id: "sagemaker_chat", title: "SageMaker Chat", defaultEnvironmentKey: "AWS_ACCESS_KEY_ID"),
        .init(id: "sagemaker_nova", title: "SageMaker Nova", defaultEnvironmentKey: "AWS_ACCESS_KEY_ID"),
        .init(id: "nlp_cloud", title: "NLP Cloud", defaultEnvironmentKey: "NLP_CLOUD_API_KEY"),
        .init(id: "petals", title: "Petals", defaultEnvironmentKey: "PETALS_API_KEY"),
        .init(id: "oobabooga", title: "Oobabooga", defaultEnvironmentKey: "OOBABOOGA_API_KEY"),
        .init(id: "ollama_chat", title: "Ollama Chat", defaultEnvironmentKey: "OLLAMA_API_KEY"),
        .init(id: "milvus", title: "Milvus", defaultEnvironmentKey: "MILVUS_API_KEY"),
        .init(id: "a2a", title: "A2A", defaultEnvironmentKey: "A2A_API_KEY"),
        .init(id: "gigachat", title: "GigaChat", defaultEnvironmentKey: "GIGACHAT_API_KEY"),
        .init(id: "nvidia_riva", title: "NVIDIA Riva", defaultEnvironmentKey: "NVIDIA_RIVA_API_KEY"),
        .init(id: "soniox", title: "Soniox", defaultEnvironmentKey: "SONIOX_API_KEY"),
        .init(id: "volcengine", title: "Volcengine", defaultEnvironmentKey: "VOLCENGINE_API_KEY"),
        .init(id: "codestral", title: "Codestral", defaultEnvironmentKey: "CODESTRAL_API_KEY"),
        .init(id: "text-completion-codestral", title: "Codestral Text Completion", defaultEnvironmentKey: "CODESTRAL_API_KEY"),
        .init(id: "qwencloud", title: "Qwen Cloud", defaultEnvironmentKey: "QWEN_API_KEY"),
        .init(id: "qwen_ai_platform", title: "Qwen AI Platform", defaultEnvironmentKey: "QWEN_API_KEY"),
        .init(id: "modelscope", title: "ModelScope", defaultEnvironmentKey: "MODELSCOPE_API_KEY"),
        .init(id: "publicai", title: "PublicAI", defaultEnvironmentKey: "PUBLICAI_API_KEY"),
        .init(id: "v0", title: "v0", defaultEnvironmentKey: "V0_API_KEY"),
        .init(id: "morph", title: "Morph", defaultEnvironmentKey: "MORPH_API_KEY"),
        .init(id: "lambda_ai", title: "Lambda AI", defaultEnvironmentKey: "LAMBDA_API_KEY"),
        .init(id: "inception", title: "Inception", defaultEnvironmentKey: "INCEPTION_API_KEY"),
        .init(id: "text-completion-inception", title: "Inception Text Completion", defaultEnvironmentKey: "INCEPTION_API_KEY"),
        .init(id: "maritalk", title: "Maritalk", defaultEnvironmentKey: "MARITALK_API_KEY"),
        .init(id: "voyage", title: "Voyage", defaultEnvironmentKey: "VOYAGE_API_KEY"),
        .init(id: "cloudflare", title: "Cloudflare", defaultEnvironmentKey: "CLOUDFLARE_API_KEY"),
        .init(id: "xinference", title: "Xinference", defaultEnvironmentKey: "XINFERENCE_API_KEY"),
        .init(id: "friendliai", title: "FriendliAI", defaultEnvironmentKey: "FRIENDLI_TOKEN"),
        .init(id: "featherless_ai", title: "Featherless AI", defaultEnvironmentKey: "FEATHERLESS_AI_API_KEY"),
        .init(id: "watsonx_text", title: "Watsonx Text", defaultEnvironmentKey: "WATSONX_API_KEY"),
        .init(id: "triton", title: "Triton", defaultEnvironmentKey: "TRITON_API_KEY"),
        .init(id: "predibase", title: "Predibase", defaultEnvironmentKey: "PREDIBASE_API_KEY"),
        .init(id: "empower", title: "Empower", defaultEnvironmentKey: "EMPOWER_API_KEY"),
        .init(id: "ragflow", title: "Ragflow", defaultEnvironmentKey: "RAGFLOW_API_KEY"),
        .init(id: "compactifai", title: "CompactifAI", defaultEnvironmentKey: "COMPACTIFAI_API_KEY"),
        .init(id: "docker_model_runner", title: "Docker Model Runner", defaultEnvironmentKey: "DOCKER_MODEL_RUNNER_API_KEY"),
        .init(id: "custom", title: "Custom", defaultEnvironmentKey: "CUSTOM_API_KEY"),
        .init(id: "litellm_proxy", title: "LiteLLM Proxy", defaultEnvironmentKey: "LITELLM_PROXY_API_KEY"),
        .init(id: "hosted_vllm", title: "Hosted vLLM", defaultEnvironmentKey: "HOSTED_VLLM_API_KEY"),
        .init(id: "tencent", title: "Tencent", defaultEnvironmentKey: "TENCENT_API_KEY"),
        .init(id: "llamafile", title: "Llamafile", defaultEnvironmentKey: "LLAMAFILE_API_KEY"),
        .init(id: "galadriel", title: "Galadriel", defaultEnvironmentKey: "GALADRIEL_API_KEY"),
        .init(id: "nebius", title: "Nebius", defaultEnvironmentKey: "NEBIUS_API_KEY"),
        .init(id: "infinity", title: "Infinity", defaultEnvironmentKey: "INFINITY_API_KEY"),
        .init(id: "deepgram", title: "Deepgram", defaultEnvironmentKey: "DEEPGRAM_API_KEY"),
        .init(id: "elevenlabs", title: "ElevenLabs", defaultEnvironmentKey: "ELEVENLABS_API_KEY"),
        .init(id: "novita", title: "Novita", defaultEnvironmentKey: "NOVITA_API_KEY"),
        .init(id: "aiohttp_openai", title: "Aiohttp OpenAI", defaultEnvironmentKey: "AIOHTTP_OPENAI_API_KEY"),
        .init(id: "langfuse", title: "Langfuse", defaultEnvironmentKey: "LANGFUSE_API_KEY"),
        .init(id: "humanloop", title: "Humanloop", defaultEnvironmentKey: "HUMANLOOP_API_KEY"),
        .init(id: "topaz", title: "Topaz", defaultEnvironmentKey: "TOPAZ_API_KEY"),
        .init(id: "sap", title: "SAP Generative AI Hub", defaultEnvironmentKey: "SAP_AI_CORE_CLIENT_ID"),
        .init(id: "assemblyai", title: "AssemblyAI", defaultEnvironmentKey: "ASSEMBLYAI_API_KEY"),
        .init(id: "charity_engine", title: "Charity Engine", defaultEnvironmentKey: "CHARITY_ENGINE_API_KEY"),
        .init(id: "github_copilot", title: "GitHub Copilot", defaultEnvironmentKey: "GITHUB_COPILOT_API_KEY"),
        .init(id: "snowflake", title: "Snowflake", defaultEnvironmentKey: "SNOWFLAKE_PAT"),
        .init(id: "gradient_ai", title: "Gradient AI", defaultEnvironmentKey: "GRADIENT_AI_API_KEY"),
        .init(id: "meta_llama", title: "Meta Llama", defaultEnvironmentKey: "LLAMA_API_KEY"),
        .init(id: "nscale", title: "Nscale", defaultEnvironmentKey: "NSCALE_API_KEY"),
        .init(id: "pg_vector", title: "PG Vector", defaultEnvironmentKey: "PG_VECTOR_API_KEY"),
        .init(id: "s3_vectors", title: "S3 Vectors", defaultEnvironmentKey: "AWS_ACCESS_KEY_ID"),
        .init(id: "valkey", title: "Valkey", defaultEnvironmentKey: "VALKEY_API_KEY"),
        .init(id: "mongodb", title: "MongoDB", defaultEnvironmentKey: "MONGODB_API_KEY")
    ]

    static func title(for id: String) -> String {
        catalog.first { $0.id == id }?.title ?? id
    }

    static func defaultEnvironmentKey(for id: String) -> String {
        catalog.first { $0.id == id }?.defaultEnvironmentKey ?? "\(id.uppercased())_API_KEY"
    }
}

struct CredentialRecord: Identifiable, Hashable, Codable {
    var id: UUID
    var displayName: String
    var providerID: String
    var environmentKey: String

    init(id: UUID = UUID(), displayName: String, providerID: String, environmentKey: String) {
        self.id = id
        self.displayName = displayName
        self.providerID = providerID
        self.environmentKey = environmentKey
    }
}

struct ProviderModel: Identifiable, Hashable, Codable {
    var id: UUID
    var displayName: String
    var providerID: String
    var litellmModel: String
    var credentialID: UUID?
    var isEnabled: Bool

    init(
        id: UUID = UUID(),
        displayName: String,
        providerID: String,
        litellmModel: String,
        credentialID: UUID? = nil,
        isEnabled: Bool = true
    ) {
        self.id = id
        self.displayName = displayName
        self.providerID = providerID
        self.litellmModel = litellmModel
        self.credentialID = credentialID
        self.isEnabled = isEnabled
    }

    private enum CodingKeys: String, CodingKey {
        case id
        case displayName
        case providerID
        case provider
        case litellmModel
        case credentialID
        case isEnabled
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        displayName = try container.decode(String.self, forKey: .displayName)
        providerID = try container.decodeIfPresent(String.self, forKey: .providerID)
            ?? ProviderModel.providerID(fromLegacyProvider: try container.decodeIfPresent(String.self, forKey: .provider))
        litellmModel = try container.decode(String.self, forKey: .litellmModel)
        credentialID = try container.decodeIfPresent(UUID.self, forKey: .credentialID)
        isEnabled = try container.decodeIfPresent(Bool.self, forKey: .isEnabled) ?? true
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(displayName, forKey: .displayName)
        try container.encode(providerID, forKey: .providerID)
        try container.encode(litellmModel, forKey: .litellmModel)
        try container.encodeIfPresent(credentialID, forKey: .credentialID)
        try container.encode(isEnabled, forKey: .isEnabled)
    }

    private static func providerID(fromLegacyProvider provider: String?) -> String {
        switch provider {
        case "openAI": "openai"
        case .some(let provider): provider
        case .none: "openai"
        }
    }
}

struct ProxyConfiguration: Codable, Equatable {
    var publicModelName: String
    var port: Int
    var activeModelID: UUID
    var models: [ProviderModel]
    var credentials: [CredentialRecord]

    static var initial: ProxyConfiguration {
        let credentials = [
            CredentialRecord(displayName: "OpenAI", providerID: "openai", environmentKey: "OPENAI_API_KEY"),
            CredentialRecord(displayName: "Anthropic", providerID: "anthropic", environmentKey: "ANTHROPIC_API_KEY"),
            CredentialRecord(displayName: "Gemini", providerID: "gemini", environmentKey: "GEMINI_API_KEY")
        ]
        let models = [
            ProviderModel(
                displayName: "GPT-5 mini",
                providerID: "openai",
                litellmModel: "openai/gpt-5-mini",
                credentialID: credentials[0].id
            ),
            ProviderModel(
                displayName: "Claude",
                providerID: "anthropic",
                litellmModel: "anthropic/claude-sonnet-4-5",
                credentialID: credentials[1].id
            ),
            ProviderModel(
                displayName: "Gemini",
                providerID: "gemini",
                litellmModel: "gemini/gemini-2.5-pro",
                credentialID: credentials[2].id
            )
        ]
        return ProxyConfiguration(
            publicModelName: "current",
            port: 4000,
            activeModelID: models[0].id,
            models: models,
            credentials: credentials
        )
    }

    private enum CodingKeys: String, CodingKey {
        case publicModelName
        case port
        case activeModelID
        case models
        case credentials
    }

    init(publicModelName: String, port: Int, activeModelID: UUID, models: [ProviderModel], credentials: [CredentialRecord]) {
        self.publicModelName = publicModelName
        self.port = port
        self.activeModelID = activeModelID
        self.models = models
        self.credentials = credentials
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        publicModelName = try container.decode(String.self, forKey: .publicModelName)
        port = try container.decode(Int.self, forKey: .port)
        activeModelID = try container.decode(UUID.self, forKey: .activeModelID)
        models = try container.decode([ProviderModel].self, forKey: .models)
        credentials = try container.decodeIfPresent([CredentialRecord].self, forKey: .credentials)
            ?? ProxyConfiguration.defaultCredentials(for: models)
    }

    private static func defaultCredentials(for models: [ProviderModel]) -> [CredentialRecord] {
        var seen = Set<String>()
        return models.compactMap { model in
            guard !seen.contains(model.providerID) else {
                return nil
            }
            seen.insert(model.providerID)
            return CredentialRecord(
                displayName: ProviderDescriptor.title(for: model.providerID),
                providerID: model.providerID,
                environmentKey: ProviderDescriptor.defaultEnvironmentKey(for: model.providerID)
            )
        }
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
