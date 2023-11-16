import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct RegisterView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @AppStorage("uid") var userID: String = ""
    @Binding var currentShowingView: String
    @State private var navigateToContentView = false
    @State private var navigateToLoginView = false

    private func isValidPassword(_ password: String) -> Bool {
        // minimum 6 characters long
        // 1 uppercase character
        // 1 special char

        return true
    }

    var body: some View {
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)

            VStack {
                HStack {
                    Text("Create an Account!")
                        .foregroundColor(.blue)
                        .font(.largeTitle)
                        .bold()

                    Spacer()
                }
                .padding()
                .padding(.top)

                Spacer()

                HStack {
                    Image(systemName: "mail")
                    TextField("Email", text: $email)

                    Spacer()

                    if email.count != 0 {
                        Image(systemName: email.isValidEmail() ? "checkmark" : "xmark")
                            .fontWeight(.bold)
                            .foregroundColor(email.isValidEmail() ? .green : .red)
                    }
                }
                .foregroundColor(.black)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(lineWidth: 2)
                        .foregroundColor(.black)
                )
                .padding()

                HStack {
                    Image(systemName: "lock")
                    SecureField("Password", text: $password)

                    Spacer()

                    if password.count != 0 {
                        Image(systemName: isValidPassword(password) ? "checkmark" : "xmark")
                            .fontWeight(.bold)
                            .foregroundColor(isValidPassword(password) ? .green : .red)
                    }
                }
                .foregroundColor(.black)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(lineWidth: 2)
                        .foregroundColor(.black)
                )
                .padding()

                Spacer()

                Button {
                    Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                        if let error = error {
                            print(error)
                            return
                        }

                        if let authResult = authResult {
                            print(authResult.user.uid)
                            userID = authResult.user.uid

                            // Save the user ID to Firestore
                            saveUserIDToFirestore()

                            navigateToContentView = true
                        }
                    }
                } label: {
                    Text("Create Your Account")
                        .foregroundColor(.black)
                        .font(.title3)
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.blue)
                        )
                        .padding(.horizontal)
                }
                .navigationTitle("Create Account")

                NavigationLink(destination: ContentView(), isActive: $navigateToContentView) {
                    EmptyView()
                }
                .hidden()

                Spacer()
                Spacer()

                Button {
                    navigateToLoginView = true
                } label: {
                    Text("Already have an account?")
                        .foregroundColor(.blue)
                }
                .padding(.top)
            }
            .background(
                NavigationLink(destination: LoginView(currentShowingView: $currentShowingView), isActive: $navigateToLoginView) {
                    EmptyView()
                }
                .hidden()
            )
        }
    }

    private func saveUserIDToFirestore() {
        let db = Firestore.firestore()

        // Add your Firestore collection and document reference
        let collectionReference = db.collection("users")
        let documentReference = collectionReference.document(userID)

        // Prepare data to be saved
        let data: [String: Any] = [
            "userID": userID,
            // Add any other user-related data you want to store
        ]

        // Save data to Firestore
        documentReference.setData(data) { error in
            if let error = error {
                print("Error adding document: \(error)")
            } else {
                print("Document added successfully!")
                // You can add any additional logic or UI updates here
            }
        }
    }
}
