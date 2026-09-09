import AppKit
import SwiftUI

final class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.regular)
        NSApp.activate(ignoringOtherApps: true)
    }
}

@main
struct LiteLLMProxyApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    @State private var store = ProxyStore(
        configService: LiteLLMConfigService(),
        processService: LiteLLMProcessService(),
        healthClient: LiteLLMHealthClient()
    )

    var body: some Scene {
        WindowGroup("LiteLLM Proxy", id: "main") {
            ContentView(store: store)
                .frame(minWidth: 920, minHeight: 620)
        }
        .commands {
            CommandGroup(after: .appInfo) {
                Button("Start Proxy") {
                    Task { await store.startProxy() }
                }
                .keyboardShortcut("r", modifiers: [.command])

                Button("Stop Proxy") {
                    store.stopProxy()
                }
                .keyboardShortcut(".", modifiers: [.command])
            }
        }
    }
}
