import AppKit

@MainActor
final class OpenLensRemoteAppDelegate: NSObject, NSApplicationDelegate {
    private var menuController: RemoteMenuController?
    private var store: RemoteAgentStore?

    private static var isRunningTests: Bool {
        ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil
            || ProcessInfo.processInfo.environment["XCInjectBundleInto"] != nil
            || NSClassFromString("XCTestCase") != nil
    }

    func applicationDidFinishLaunching(_ notification: Notification) {
        guard !Self.isRunningTests else { return }
        do {
            let store = try RemoteAgentStore()
            self.store = store
            menuController = RemoteMenuController(store: store)
        } catch {
            let alert = NSAlert(error: error)
            alert.messageText = "OpenLens Remote could not start"
            alert.runModal()
            NSApplication.shared.terminate(nil)
        }
    }

    func applicationWillTerminate(_ notification: Notification) {
        store?.stopAll()
    }
}
