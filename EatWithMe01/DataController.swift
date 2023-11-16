import Foundation
import CoreData
import FirebaseAuth
class DataController: ObservableObject {
    let container: NSPersistentContainer
    
    init() {
        container = NSPersistentContainer(name: "FoodModel")
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Failed to load data in DataController \(error.localizedDescription)")
            }
        }
    }
    
    func save(context: NSManagedObjectContext) {
        do {
            try context.save()
            print("Data saved successfully.")
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    func addFood(name: String, calories: Double, context: NSManagedObjectContext) {
        let newFood = Food(context: context)
        newFood.name = name
        newFood.calories = calories
        newFood.date = Date()
        newFood.userID = Auth.auth().currentUser?.uid // Lägg till userID

        save(context: context)
    }

    
    func editFood(food: Food, name: String, calories: Double, context: NSManagedObjectContext) {
        food.date = Date()
        food.name = name
        food.calories = calories
        
        save(context: context)
    }
}
