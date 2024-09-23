//
//  LoginView.swift
//  Snacktacular
//
//  Created by Lori Rothermel on 9/23/24.
//

import SwiftUI
import Firebase
import FirebaseAuth



struct LoginView: View {
    @FocusState private var focusField: Field?
    
    @State private var email = ""
    @State private var password = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var buttonsDisabled = true
    
    
    
    enum Field {
        case email
        case password
    }  // enum Field
    
    var body: some View {
        NavigationStack {
            Image("logo")
                .resizable()
                .scaledToFit()
                .padding()
            
            Group {
                TextField("email", text: $email)
                    .keyboardType(.emailAddress)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .submitLabel(.next)
                    .focused($focusField, equals: .email)
                    .onSubmit {
                        focusField = .password
                    }  // .onSubmit
                    .onChange(of: email) { _, _ in
                         enableButtons()
                    }  // .onChange
                
                SecureField("password", text: $password)
                    .textInputAutocapitalization(.never)
                    .submitLabel(.done)
                    .focused($focusField, equals: .password)
                    .onSubmit {
                        focusField = nil
                    }  // .onSubmit
                    .onChange(of: password) { _, _ in
                         enableButtons()
                    }  // .onChange
                
            }  // Group
            .font(.title3)
            .textFieldStyle(.roundedBorder)
            .overlay {
                RoundedRectangle(cornerRadius: 5)
                    .stroke(.gray.opacity(0.5), lineWidth: 2)
            }  // .overlay
            .padding(.horizontal)
            
            HStack {
                Button {
                    register()
                } label: {
                    Text("Sign Up")
                }  // Button - Sign Up
                .padding(.trailing)
                
                Button {
                    login()
                } label: {
                    Text("Log In")
                }  // Button - Log In
                .padding(.leading)
                
            }  // HStack
            .disabled(buttonsDisabled)
            .buttonStyle(.borderedProminent)
            .tint(Color("SnackColor"))
            .font(.title2)
            .padding(.top)
            .navigationBarTitleDisplayMode(.inline)
            
        }  // NavigationStack
        .alert(alertMessage, isPresented: $showingAlert) {
            Button("OK", role: .cancel) {}
        }  // .alert
        
    }  // some View
    
    
    func enableButtons() {
        let emailIsGood = email.count > 6 && email.contains("@")
        let passwordIsGood = password.count >= 6
        buttonsDisabled = !(emailIsGood && passwordIsGood)
        
    }  // func enableButtons
    
    
    func register() {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {   // LogIn error occurred.
                print("👹 REGISTRATION ERROR: \(error.localizedDescription)")
                alertMessage = "REGISTRATION ERROR: \(error.localizedDescription)"
                showingAlert = true
            } else {
                print("😇 Registration Success!!!!")
                    // TODO: Load ListView
            }  // if else
        }  // Auth.auth().createUser
        
    }  // func register
    
    
    
    func login() {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {   // LogIn error occurred.
                print("👹 LOGIN ERROR: \(error.localizedDescription)")
                alertMessage = "LOGIN ERROR: \(error.localizedDescription)"
                showingAlert = true
            } else {
                print("😇 Login Success!!!!")
                    // TODO: Load ListView
            }  // if else
        }  // Auth.auth().signIn
        
    }  // func login
    
}  // LoginView

#Preview {
    LoginView()
}
