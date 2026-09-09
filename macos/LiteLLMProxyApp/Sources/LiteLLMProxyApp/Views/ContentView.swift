import SwiftUI

struct ContentView: View {
    @Bindable var store: ProxyStore
    @SceneStorage("selectedSection") private var selectedSection = AppSection.dashboard

    var body: some View {
        NavigationSplitView {
            SidebarView(selection: $selectedSection)
            .navigationSplitViewColumnWidth(min: 240, ideal: 280)
        } detail: {
            switch selectedSection {
            case .dashboard:
                DetailView(store: store)
            case .models:
                ModelsView(store: store)
            case .credentials:
                CredentialsManagementView(store: store)
            }
        }
        .onChange(of: store.configuration.activeModelID) {
            store.saveConfiguration()
        }
    }
}
