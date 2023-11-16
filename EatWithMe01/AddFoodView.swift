import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct AddFoodView: View {
    @State private var name = ""
    @State private var calories: Double = 0
    @Environment(\.managedObjectContext) var managedObjContext
    @Environment(\.dismiss) var dismiss

    // Funktionen för att lägga till i Firestore
    private func addFoodToFirestore() {
        guard let userID = Auth.auth().currentUser?.uid else {
            print("User not logged in.")
            return
        }
        

        let db = Firestore.firestore()
        let collectionReference = db.collection("FoodModel")
        let documentReference = collectionReference.document()

        let data: [String: Any] = [
            "name": name,
            "calories": calories,
            "userID": userID
            
        ]

        documentReference.setData(data) { error in
            if let error = error {
                print("Error adding document: \(error)")
            } else {
                print("Document added successfully!")
            }
        }
    }

    var body: some View {
        Form {
            Section() {
                TextField("Food name", text: $name)

                VStack {
                    Text("Calories: \(Int(calories))")
                    Slider(value: $calories, in: 0...1000, step: 10)
                }
                .padding()

                HStack {
                    Spacer()
                    Button("Submit") {
                        addFoodToFirestore()
                        DataController().addFood(
                                             name: name,
                                             calories: calories,
                                             context: managedObjContext)
                                         dismiss()
                        
                    }
                    Spacer()
                }
            }
        }
    }
}
