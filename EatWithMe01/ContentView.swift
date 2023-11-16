import SwiftUI
import FirebaseFirestore
import FirebaseAuth
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) var managedObjContext
    @FetchRequest(
        entity: Food.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Food.date, ascending: false)],
        predicate: NSPredicate(format: "userID == %@", Auth.auth().currentUser?.uid ?? "")
    ) var food: FetchedResults<Food>
    @StateObject private var dataController = DataController()
    @State private var showingAddView = false

    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Text("\(Int(totalCaloriesToday())) KCal (Today)")
                    .foregroundColor(.gray)
                    .padding([.horizontal])
                List {
                    ForEach(food) { food in
                        NavigationLink(destination: EditFoodView(food: food)) {
                            HStack {
                                VStack(alignment: .leading, spacing: 6) {
                                    Text(food.name!)
                                        .bold()

                                    Text("\(Int(food.calories))") + Text(" calories").foregroundColor(.red)
                                }
                                Spacer()
                                Text(calcTimeSince(date: food.date!))
                                    .foregroundColor(.gray)
                                    .italic()
                            }
                        }
                    }
                    .onDelete(perform: deleteFood)
                }
                .listStyle(.plain)
            }
            .navigationTitle("EatWithMe")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddView.toggle()
                    } label: {
                        Label("Add food", systemImage: "plus.circle")
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
            }
            .sheet(isPresented: $showingAddView) {
                AddFoodView()
            }
        }
        .navigationViewStyle(.stack)
    }

    private func deleteFood(offsets: IndexSet) {
        withAnimation {
            offsets.map { food[$0] }
                .forEach(managedObjContext.delete)

            dataController.save(context: managedObjContext)
        }
    }

    private func totalCaloriesToday() -> Double {
        var caloriesToday: Double = 0
        for item in food {
            if Calendar.current.isDateInToday(item.date!) {
                caloriesToday += item.calories
            }
        }
        print("Calories today: \(caloriesToday)")
        return caloriesToday
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
    
    
    
    
}
