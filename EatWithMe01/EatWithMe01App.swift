
import SwiftUI
import FirebaseCore


@main
struct EatWithMe01App: App {
    @StateObject private var dataController = DataController()

    
    init() {
         FirebaseApp.configure()
     }
     
     var body: some Scene {
         WindowGroup {
             SplashScreen()
                 .environment(\.managedObjectContext,
                                               dataController.container.viewContext)
         }
     }
 }
