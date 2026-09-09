import SwiftUI

struct CredentialsManagementView: View {
    @Bindable var store: ProxyStore
    @State private var selectedCredentialID: UUID?

    var body: some View {
        HSplitView {
            credentialList
                .frame(minWidth: 280, idealWidth: 320)

            credentialEditor
                .frame(minWidth: 420)
        }
        .navigationTitle("Credentials")
        .toolbar {
            ToolbarItemGroup {
                Button {
                    store.addCredential()
                    selectedCredentialID = store.configuration.credentials.last?.id
                } label: {
                    Label("Add Credential", systemImage: "plus")
                }

                Button(role: .destructive) {
                    guard let selectedCredentialID else {
                        return
                    }
                    store.removeCredential(id: selectedCredentialID)
                    self.selectedCredentialID = store.configuration.credentials.first?.id
                } label: {
                    Label("Delete Credential", systemImage: "trash")
                }
                .disabled(selectedCredentialID == nil)
            }
        }
        .onAppear {
            selectedCredentialID = selectedCredentialID ?? store.configuration.credentials.first?.id
        }
    }

    private var credentialList: some View {
        List(selection: $selectedCredentialID) {
            ForEach(store.configuration.credentials) { credential in
                HStack(spacing: 10) {
                    Image(systemName: "key")
                        .foregroundStyle(.secondary)
                        .frame(width: 16)
                    VStack(alignment: .leading, spacing: 2) {
                        Text(credential.displayName)
                            .lineLimit(1)
                        Text(ProviderDescriptor.title(for: credential.providerID))
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                    }
                }
                .tag(credential.id)
            }
        }
    }

    @ViewBuilder
    private var credentialEditor: some View {
        if let id = selectedCredentialID,
           let credential = store.configuration.credentials.first(where: { $0.id == id }),
           let name = store.bindingForCredential(id: id, \.displayName),
           let providerID = store.bindingForCredential(id: id, \.providerID),
           let environmentKey = store.bindingForCredential(id: id, \.environmentKey) {
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(credential.displayName)
                            .font(.largeTitle.bold())
                            .lineLimit(1)
                        Text(credential.environmentKey)
                            .foregroundStyle(.secondary)
                            .textSelection(.enabled)
                    }

                    GroupBox("Credential") {
                        Grid(alignment: .leading, horizontalSpacing: 18, verticalSpacing: 10) {
                            GridRow {
                                Text("Name").foregroundStyle(.secondary)
                                TextField("", text: name)
                                    .textFieldStyle(.roundedBorder)
                            }
                            GridRow {
                                Text("Provider").foregroundStyle(.secondary)
                                Picker("", selection: providerID) {
                                    ForEach(ProviderDescriptor.catalog) { provider in
                                        Text(provider.title).tag(provider.id)
                                    }
                                }
                                .labelsHidden()
                                .frame(maxWidth: 220)
                            }
                            GridRow {
                                Text("Provider id").foregroundStyle(.secondary)
                                TextField("", text: providerID)
                                    .textFieldStyle(.roundedBorder)
                            }
                            GridRow {
                                Text("Environment key").foregroundStyle(.secondary)
                                TextField("", text: environmentKey)
                                    .textFieldStyle(.roundedBorder)
                            }
                            GridRow {
                                Text("Secret").foregroundStyle(.secondary)
                                SecureField("API key or token", text: secretBinding(for: id))
                                    .textFieldStyle(.roundedBorder)
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
            ContentUnavailableView("Select a Credential", systemImage: "key")
        }
    }

    private func secretBinding(for id: UUID) -> Binding<String> {
        Binding {
            store.credentialSecrets[id] ?? ""
        } set: { value in
            store.saveCredentialSecret(value, credentialID: id)
        }
    }
}
