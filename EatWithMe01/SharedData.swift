
import SwiftUI
import FirebaseFirestore
import FirebaseAuth

class SharedData: ObservableObject {
    @Published var newFood: Food?
}
