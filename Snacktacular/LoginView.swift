//
//  LoginView.swift
//  Snacktacular
//
//  Created by Lori Rothermel on 4/2/23.
//

import SwiftUI
import Firebase

struct LoginView: View {
    
    enum Field {
        case email, password
    }
    
    
    @State private var email = ""
    @State private var password = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var buttonsDisabled = true
    @State private var presentSheet = false
    
    @FocusState private var focusField: Field?
    
    
    
    var body: some View {
        VStack {
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
                    .focused($focusField, equals: .email)
                    .onSubmit {
                        focusField = .password
                    }  // .onSubmit
                    .onChange(of: email) { _ in
                        enableButtons()
                    }
                SecureField("Password", text: $password)
                    .textInputAutocapitalization(.never)
                    .submitLabel(.done)
                    .focused($focusField, equals: .password)
                    .onSubmit {
                        focusField = nil    // Will dismiss the keyboard
                    }
                    .onChange(of: password) { _ in
                        enableButtons()
                    }
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
            .disabled(buttonsDisabled)
            .buttonStyle(.borderedProminent)
            .tint(Color("SnackColor"))
            .font(.title2)
            .padding(.top)
        }  // VStack
        .alert(alertMessage, isPresented: $showingAlert) {
            Button("OK", role: .cancel) {}
        }  // .alert
        .onAppear {
            // if logged in when app runs navigate to the new screen & skip login screen.
            if Auth.auth().currentUser != nil {
                print("🪵 Login Successful!")
                presentSheet = true
            }
        }  // .onAppear
        .fullScreenCover(isPresented: $presentSheet) {
            ListView()
        }
        
        
    }  // some Veiw
    
    
    func enableButtons() {
        let emailsGood = email.count >= 6 && email.contains("@")
        let passwordIsGood = password.count >= 6
        
        buttonsDisabled = !(emailsGood && passwordIsGood)
    }  // func enableButtons
    
        
    func registrer() {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {    // login error occurred
                print("🤮 NEW ACCOUNT ERROR: \(error.localizedDescription)")
                alertMessage = "New Account Error: \(error.localizedDescription)"
                showingAlert = true
            } else {
                print("🤡 Create New Account Success!")
                presentSheet = true
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
                presentSheet = true
            }  // if let error
        }  // Auth.auth()
    }  // func login
    
    
    
}  // LoginView


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
