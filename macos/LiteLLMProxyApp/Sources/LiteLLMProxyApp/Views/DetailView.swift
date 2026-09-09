import SwiftUI

struct DetailView: View {
    @Bindable var store: ProxyStore

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                HeaderView(store: store)
                EndpointView(store: store)
                ActiveModelView(store: store)
                CredentialsView(store: store)
                HealthView(store: store)
            }
            .padding(24)
            .frame(maxWidth: 780, alignment: .leading)
        }
        .toolbar {
            ToolbarItemGroup {
                Button {
                    Task { await store.refreshHealth() }
                } label: {
                    Label("Refresh", systemImage: "arrow.clockwise")
                }

                Button {
                    Task { await store.restartProxy() }
                } label: {
                    Label("Restart", systemImage: "restart")
                }

                Button {
                    store.stopProxy()
                } label: {
                    Label("Stop", systemImage: "stop.fill")
                }
            }
        }
    }
}

private struct HeaderView: View {
    @Bindable var store: ProxyStore

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Local LiteLLM Proxy")
                        .font(.largeTitle.bold())
                    Text("Stable OpenAI-compatible endpoint backed by the selected LiteLLM model")
                        .foregroundStyle(.secondary)
                }
                Spacer()
                StatusBadge(status: store.status)
            }

            HStack {
                Button {
                    Task { await store.startProxy() }
                } label: {
                    Label("Start Proxy", systemImage: "play.fill")
                }
                .buttonStyle(.borderedProminent)

                Button {
                    Task { await store.restartProxy() }
                } label: {
                    Label("Apply and Restart", systemImage: "arrow.triangle.2.circlepath")
                }
            }
        }
    }
}

private struct EndpointView: View {
    @Bindable var store: ProxyStore

    var body: some View {
        GroupBox("External Interface") {
            Grid(alignment: .leading, horizontalSpacing: 18, verticalSpacing: 10) {
                GridRow {
                    Text("Base URL").foregroundStyle(.secondary)
                    Text(store.baseURL).textSelection(.enabled)
                }
                GridRow {
                    Text("Model").foregroundStyle(.secondary)
                    Text(store.configuration.publicModelName).textSelection(.enabled)
                }
                GridRow {
                    Text("Local Key").foregroundStyle(.secondary)
                    SecureField("", text: $store.localProxyKey)
                        .textFieldStyle(.roundedBorder)
                        .onChange(of: store.localProxyKey) {
                            try? KeychainService().save(store.localProxyKey, account: "LITELLM_MASTER_KEY")
                            store.saveConfiguration()
                        }
                }
                GridRow {
                    Text("Port").foregroundStyle(.secondary)
                    TextField("", value: $store.configuration.port, format: .number)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 100)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical, 6)
        }
    }
}

private struct ActiveModelView: View {
    @Bindable var store: ProxyStore

    var body: some View {
        GroupBox("Active Model") {
            if let model = store.activeModel {
                Grid(alignment: .leading, horizontalSpacing: 18, verticalSpacing: 10) {
                    GridRow {
                        Text("Provider").foregroundStyle(.secondary)
                        Text(model.provider.title)
                    }
                    GridRow {
                        Text("LiteLLM model").foregroundStyle(.secondary)
                        Text(model.litellmModel).textSelection(.enabled)
                    }
                    GridRow {
                        Text("Public alias").foregroundStyle(.secondary)
                        TextField("", text: $store.configuration.publicModelName)
                            .textFieldStyle(.roundedBorder)
                            .frame(maxWidth: 240)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical, 6)
            }
        }
    }
}

private struct CredentialsView: View {
    @Bindable var store: ProxyStore

    var body: some View {
        GroupBox("Provider Keys") {
            VStack(alignment: .leading, spacing: 10) {
                ForEach(ProviderKind.allCases) { provider in
                    HStack {
                        Text(provider.title)
                            .frame(width: 120, alignment: .leading)
                            .foregroundStyle(.secondary)
                        SecureField(provider.environmentKey, text: binding(for: provider))
                            .textFieldStyle(.roundedBorder)
                    }
                }
            }
            .padding(.vertical, 6)
        }
    }

    private func binding(for provider: ProviderKind) -> Binding<String> {
        Binding {
            store.providerKeys[provider] ?? ""
        } set: { value in
            store.saveProviderKey(value, provider: provider)
        }
    }
}

private struct HealthView: View {
    @Bindable var store: ProxyStore

    var body: some View {
        GroupBox("Runtime") {
            VStack(alignment: .leading, spacing: 10) {
                if case .failed(let message) = store.status {
                    Label(message, systemImage: "exclamationmark.triangle.fill")
                        .foregroundStyle(.red)
                }

                if store.discoveredModels.isEmpty {
                    Text("No models reported yet")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(store.discoveredModels, id: \.self) { model in
                        Label(model, systemImage: "checkmark.circle")
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical, 6)
        }
    }
}

private struct StatusBadge: View {
    let status: ProxyStatus

    var body: some View {
        Label(status.title, systemImage: systemImage)
            .font(.caption.weight(.semibold))
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(.regularMaterial, in: Capsule())
            .foregroundStyle(color)
    }

    private var systemImage: String {
        switch status {
        case .stopped: "pause.circle"
        case .starting: "clock"
        case .running: "checkmark.circle.fill"
        case .failed: "exclamationmark.triangle.fill"
        }
    }

    private var color: Color {
        switch status {
        case .stopped: .secondary
        case .starting: .orange
        case .running: .green
        case .failed: .red
        }
    }
}
