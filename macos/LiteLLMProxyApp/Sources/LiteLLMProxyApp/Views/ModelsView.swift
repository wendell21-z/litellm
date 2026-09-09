import SwiftUI

struct ModelsView: View {
    @Bindable var store: ProxyStore
    @State private var selectedModelID: UUID?

    var body: some View {
        HSplitView {
            modelList
                .frame(minWidth: 280, idealWidth: 320)

            modelEditor
                .frame(minWidth: 420)
        }
        .navigationTitle("Models")
        .toolbar {
            ToolbarItemGroup {
                Button {
                    store.addModel()
                    selectedModelID = store.configuration.activeModelID
                } label: {
                    Label("Add Model", systemImage: "plus")
                }

                Button(role: .destructive) {
                    guard let selectedModelID else {
                        return
                    }
                    store.removeModel(id: selectedModelID)
                    self.selectedModelID = store.configuration.activeModelID
                } label: {
                    Label("Delete Model", systemImage: "trash")
                }
                .disabled(store.configuration.models.count <= 1 || selectedModelID == nil)
            }
        }
        .onAppear {
            selectedModelID = selectedModelID ?? store.configuration.activeModelID
        }
    }

    private var modelList: some View {
        List(selection: $selectedModelID) {
            ForEach(store.configuration.models) { model in
                HStack(spacing: 10) {
                    Image(systemName: icon(for: model.provider))
                        .foregroundStyle(.secondary)
                        .frame(width: 16)
                    VStack(alignment: .leading, spacing: 2) {
                        HStack {
                            Text(model.displayName)
                                .lineLimit(1)
                            if model.id == store.configuration.activeModelID {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.caption)
                                    .foregroundStyle(.green)
                            }
                        }
                        Text(model.litellmModel)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                    }
                }
                .tag(model.id)
                .contextMenu {
                    Button("Use as Active Model") {
                        store.selectModel(model)
                    }
                    Button("Delete", role: .destructive) {
                        store.removeModel(id: model.id)
                        selectedModelID = store.configuration.activeModelID
                    }
                    .disabled(store.configuration.models.count <= 1)
                }
            }
        }
    }

    @ViewBuilder
    private var modelEditor: some View {
        if let id = selectedModelID,
           let selectedModel = store.configuration.models.first(where: { $0.id == id }),
           let name = store.bindingForModel(id: id, \.displayName),
           let provider = store.bindingForModel(id: id, \.provider),
           let model = store.bindingForModel(id: id, \.litellmModel) {
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(selectedModel.displayName)
                                .font(.largeTitle.bold())
                                .lineLimit(1)
                            Text(selectedModel.provider.title)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        Button {
                            store.selectModel(selectedModel)
                        } label: {
                            Label("Set Active", systemImage: "checkmark.circle")
                        }
                        .buttonStyle(.borderedProminent)
                        .disabled(selectedModel.id == store.configuration.activeModelID)
                    }

                    GroupBox("Configuration") {
                        Grid(alignment: .leading, horizontalSpacing: 18, verticalSpacing: 10) {
                            GridRow {
                                Text("Name").foregroundStyle(.secondary)
                                TextField("", text: name)
                                    .textFieldStyle(.roundedBorder)
                            }
                            GridRow {
                                Text("Provider").foregroundStyle(.secondary)
                                Picker("", selection: provider) {
                                    ForEach(ProviderKind.allCases) { provider in
                                        Text(provider.title).tag(provider)
                                    }
                                }
                                .labelsHidden()
                                .frame(maxWidth: 220)
                            }
                            GridRow {
                                Text("LiteLLM model").foregroundStyle(.secondary)
                                TextField("", text: model)
                                    .textFieldStyle(.roundedBorder)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.vertical, 6)
                    }

                    GroupBox("Generated Alias") {
                        Grid(alignment: .leading, horizontalSpacing: 18, verticalSpacing: 10) {
                            GridRow {
                                Text("Public model").foregroundStyle(.secondary)
                                Text(store.configuration.publicModelName)
                                    .textSelection(.enabled)
                            }
                            GridRow {
                                Text("API key env").foregroundStyle(.secondary)
                                Text(selectedModel.provider.environmentKey)
                                    .textSelection(.enabled)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.vertical, 6)
                    }
                }
                .padding(24)
                .frame(maxWidth: 720, alignment: .leading)
            }
        } else {
            ContentUnavailableView("Select a Model", systemImage: "square.stack.3d.up")
        }
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
