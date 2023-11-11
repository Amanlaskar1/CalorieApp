
import SwiftUI

@main
struct EatWithMe01App: App {
    @StateObject private var dataController = DataController()

    var body: some Scene {
        WindowGroup {
            SplashScreen()
                .environment(\.managedObjectContext,
                              dataController.container.viewContext)
        }
    }
}
