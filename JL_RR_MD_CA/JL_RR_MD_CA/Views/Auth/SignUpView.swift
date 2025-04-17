//
//  SignUpView.swift
//  JL_RR_MD_CA
//
//  Created by Tanmay Bhande on 16/04/25.
//

import SwiftUI

struct SignUpView: View {
    @Environment(\.dismiss) var dismiss
    @State private var name = ""
    @State private var email = ""
    @State private var phone = ""
    @State private var password = ""
    @State private var repeatPassword = ""
    @State private var agreedToTerms = false
    @State private var showAlert = false
    @State private var alertMessage = ""

    var body: some View {
        VStack(spacing: 20) {
            Text("Sign Up").font(.largeTitle).bold()
            TextField("Full Name", text: $name).textFieldStyle(.roundedBorder)
            TextField("Email", text: $email).textFieldStyle(.roundedBorder)
            TextField("Phone", text: $phone).textFieldStyle(.roundedBorder)
            SecureField("Password", text: $password).textFieldStyle(.roundedBorder)
            SecureField("Repeat Password", text: $repeatPassword).textFieldStyle(.roundedBorder)
            
            Toggle("Agree to Terms & Conditions", isOn: $agreedToTerms)
            
            Button("Sign Up") {
                signUp()
            }
            .buttonStyle(.borderedProminent)
            
            Button("Already have an account? Login") {
                dismiss()
            }
        }
        .padding()
        .alert("Oops", isPresented: $showAlert, actions: {
            Button("OK", role: .cancel) { }
        }, message: {
            Text(alertMessage)
        })
    }

    func signUp() {
        guard !name.isEmpty, !email.isEmpty, !phone.isEmpty, !password.isEmpty else {
            alertMessage = "All fields are required"
            showAlert = true
            return
        }
        guard password == repeatPassword else {
            alertMessage = "Passwords do not match"
            showAlert = true
            return
        }
        guard agreedToTerms else {
            alertMessage = "Please agree to terms"
            showAlert = true
            return
        }

        let user = User(name: name, email: email, phone: phone, password: password)
        UserManager.shared.saveUser(user)
        dismiss()
    }
}
