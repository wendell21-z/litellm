import SwiftUI

struct SidebarView: View {
    let models: [ProviderModel]
    @Binding var selection: UUID

    var body: some View {
        List(selection: $selection) {
            Section("Models") {
                ForEach(models) { model in
                    HStack(spacing: 10) {
                        Image(systemName: icon(for: model.provider))
                            .foregroundStyle(.secondary)
                            .frame(width: 16)
                        VStack(alignment: .leading, spacing: 2) {
                            Text(model.displayName)
                                .lineLimit(1)
                            Text(model.litellmModel)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .lineLimit(1)
                        }
                    }
                    .tag(model.id)
                }
            }
        }
        .listStyle(.sidebar)
        .navigationTitle("LiteLLM")
    }

    private func icon(for provider: ProviderKind) -> String {
        switch provider {
        case .openAI: "sparkles"
        case .anthropic: "text.bubble"
        case .gemini: "diamond"
        case .openRouter: "point.3.connected.trianglepath.dotted"
        case .bedrock: "server.rack"
        }
    }
}
