import SwiftUI

@main
struct AOV_KDApp: App {
    @StateObject var logStore = LogStore()

    var body: some Scene {
        WindowGroup {
            SplashView() // ← Dùng splash đầu tiên
                .environmentObject(logStore)
        }
    }
}
