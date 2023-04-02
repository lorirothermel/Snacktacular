//
//  LoginView.swift
//  Snacktacular
//
//  Created by Lori Rothermel on 4/2/23.
//

import SwiftUI
import Firebase

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    
    var body: some View {
        NavigationStack {
            Image("logo")
                .resizable()
                .scaledToFit()
                .padding()
            Group {
                TextField("E-mail", text: $email)
                    .keyboardType(.emailAddress)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .submitLabel(.next)
                SecureField("Password", text: $password)
                    .textInputAutocapitalization(.never)
                    .submitLabel(.done)
            }  // Group
            .textFieldStyle(.roundedBorder)
            .overlay {
                RoundedRectangle(cornerRadius: 5)
                    .stroke(.gray.opacity(0.5), lineWidth: 2)
            }  // .overlay
            .padding(.horizontal)
            
            HStack {
                Button {
                    registrer()
                } label: {
                    Text("Sign Up")
                }  // Button - Login
                .padding(.trailing)
                Button {
                    login()
                } label: {
                    Text("Login")
                }
                .padding(.leading)
            }  // HStack
            .buttonStyle(.borderedProminent)
            .tint(Color("SnackColor"))
            .font(.title2)
            .padding(.top)
            .navigationBarTitleDisplayMode(.inline)
        }  // NavigationStack
        .alert(alertMessage, isPresented: $showingAlert) {
            Button("OK", role: .cancel) {}
        }
    }  // some Veiw
    
    func registrer() {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {    // login error occurred
                print("🤮 NEW ACCOUNT ERROR: \(error.localizedDescription)")
                alertMessage = "New Account Error: \(error.localizedDescription)"
                showingAlert = true
            } else {
                print("🤡 Create New Account Success!")
                // TODO: Load ListView
            }  // if let error
        }  // Auth.auth()
    }  // func register
    
    
    func login() {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                print("🤮 LOGIN ERROR: \(error.localizedDescription)")
                alertMessage = "LOGIN ERROR: \(error.localizedDescription)"
                showingAlert = true
            } else {
                print("🪵 Login Successful!")
                // TODO: Load ListView
            }  // if let error
        }  // Auth.auth()
    }  // func login
    
    
    
}  // LoginView


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
