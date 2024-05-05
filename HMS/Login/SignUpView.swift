//
//  SignUpView.swift
//  HMS
//
//  Created by Sarthak on 23/04/24.
//

import SwiftUI
import Firebase

struct SignUpView: View {
    @State var PatientData = PatientModel()
    @State private var fullName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var contactNo = ""
    @State private var showAlert = false // State variable to control alert presentation
    @State private var userType: UserType = .patient
    @ObservedObject var userTypeManager: UserTypeManager
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Create Account")
                    .font(.largeTitle)
                    .padding(.bottom)
                    .bold()
                
                InputFieldView(data: $fullName, title: "Full Name").padding(.top, -10)
                
                InputFieldView(data: $email, title: "Email").padding(.top, 1)
                
                InputFieldView(data: $contactNo, title: "Phone Number").padding(.top, 1)
                
                ZStack {
                    SecureField("", text: $password)
                        .padding(.horizontal, 10)
                        .frame(width: 360, height: 52)
                        .overlay(
                            RoundedRectangle(cornerSize: CGSize(width: 4, height: 4))
                                .stroke(Color.gray, lineWidth: 1)
                        )
                    HStack {
                        Text("Password")
                            .font(.headline)
                            .fontWeight(.medium)
                            .foregroundColor(Color.black)
                            .multilineTextAlignment(.leading)
                            .padding(.bottom, 2)
                            .background(Color(Color.white))
                        Spacer()
                    }
                    .padding(.leading, 18)
                    .offset(CGSize(width: 0, height: -25))
                }.padding(.top, 1)
                
                ZStack {
                    SecureField("", text: $confirmPassword)
                        .padding(.horizontal, 10)
                        .frame(width: 360, height: 52)
                        .overlay(
                            RoundedRectangle(cornerSize: CGSize(width: 4, height: 4))
                                .stroke(Color.gray, lineWidth: 1)
                        )
                    HStack {
                        Text("Confirm Password")
                            .font(.headline)
                            .fontWeight(.medium)
                            .foregroundColor(Color.black)
                            .multilineTextAlignment(.leading)
                            .padding(.bottom, 0)
                            .background(Color(Color.white))
                        Spacer()
                    }
                    .padding(.leading, 18)
                    .offset(CGSize(width: 0, height: -25))
                }.padding(.top, 4)
                NavigationLink(destination: PdetailView(patientData: PatientModel(
                                    name: fullName,
                                    contact: contactNo,
                                    email: email
                ))) {
                    Button(action: register) {
                        Text("Sign Up")
                            .fontWeight(.heavy)
                            .font(.title3)
                            .frame(width: 300, height: 50)
                            .foregroundColor(.white)
                            .background(Color.black)
                            .cornerRadius(40)
                    }
                    .disabled(!isFormValid)
                    .alert(isPresented: $showAlert) {
                        Alert(
                            title: Text("Error"),
                            message: Text("Passwords do not match."),
                            dismissButton: .default(Text("OK"))
                        )
                    }
                }
                
                HStack {
                    Text("Already have an account?")
                    Button(action: {}, label: {
                        Text("Log In").fontWeight(.light)
                            .foregroundColor(Color.blue)
                            .underline()
                    })
                    
                }
            }
            .padding()
            .alert(isPresented: $showAlert) { // Show alert only when showAlert is true
                Alert(
                    title: Text("Password Mismatch"),
                    message: Text("Please ensure your passwords match."),
                    dismissButton: .default(Text("OK"))
                )
            }
        }.padding(.bottom,100)
    }
    
    var isFormValid: Bool {
        !(fullName.isEmpty || email.isEmpty || contactNo.isEmpty || password.isEmpty || confirmPassword.isEmpty || password != confirmPassword)
    }
    
    func register() {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                print(error.localizedDescription)
            }
            else{
                if let result = result {
                    let userUID = result.user.uid
                    let userType = "patient"
                    addUserType(userUID: userUID, userType: userType)
                    userTypeManager.userType = .patient
                    userTypeManager.userID = userUID
                    print("user created")
                    addUserData(userUID: userUID)
                }
            }
        }
    }
    
    func addUserType(userUID: String, userType: String) {
        let db = Firestore.firestore()
        let ref = db.collection("userType").document(userUID)
        ref.setData([
            "authID": userUID,
            "user": userType
        ]) { error in
            if let error = error {
                print("Error setting user type: \(error.localizedDescription)")
            } else {
                print("User type \(userType) added for UID: \(userUID)")
            }
        }
    }
    
    func addUserData(userUID: String) {
        let PatientData = [
            "userUID": userUID,
            "Name": fullName,
            "Email": email,
            "Contact": contactNo,
        ]
    }
}
