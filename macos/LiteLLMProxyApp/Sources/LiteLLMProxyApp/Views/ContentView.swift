import SwiftUI

struct ContentView: View {
    @Bindable var store: ProxyStore

    var body: some View {
        NavigationSplitView {
            SidebarView(
                models: store.configuration.models,
                selection: $store.configuration.activeModelID
            )
            .navigationSplitViewColumnWidth(min: 240, ideal: 280)
        } detail: {
            DetailView(store: store)
        }
        .onChange(of: store.configuration.activeModelID) {
            store.saveConfiguration()
        }
    }
}
