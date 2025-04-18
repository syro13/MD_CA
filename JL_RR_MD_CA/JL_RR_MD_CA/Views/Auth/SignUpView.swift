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
    @State private var showAlert = false
    @State private var alertMessage = ""

    var body: some View {
        ZStack {
            // Background image
            VStack {
                Image("bread1")
                    .ignoresSafeArea()
                Spacer()
            }

            VStack {
                Spacer()

                VStack(spacing: 20) {
                    Text("Sign Up")
                        .font(.title.bold())
                        .foregroundColor(.yellow)
                        .padding(.bottom,2)

                    customField(label: "Full Name", text: $name, placeholder: "Enter your name")
                    customField(label: "Email", text: $email, placeholder: "Enter your email")
                    customSecureField(label: "Password", text: $password, placeholder: "Enter your password")
                    customSecureField(label: "Repeat Password", text: $repeatPassword, placeholder: "Repeat your password")

                    // Styled Sign Up Button
                    Button(action: {
                        signUp()
                    }) {
                        Text("Sign Up")
                            .frame(maxWidth: .infinity)
                            .frame(height: 55)
                            .background(Color.yellow)
                            .foregroundColor(Color(red: 40/255, green: 39/255, blue: 39/255))
                            .font(.system(size: 18, weight: .regular))
                            .cornerRadius(40)
                    }

                    // Already have an account link
                    HStack(spacing: 4) {
                        Text("Already have an account?")
                            .foregroundColor(.gray)
                            .font(.system(size: 18))
                        Button("Login") {
                            dismiss()
                        }
                        .foregroundColor(.yellow)
                        .font(.system(size: 18, weight: .semibold))
                    }
                }
                .padding(30)
                .background(
                    Color(red: 40/255, green: 39/255, blue: 39/255)
                        .clipShape(RoundedCorners(radius: 70, corners: [.topLeft, .topRight]))
                        .ignoresSafeArea()
                )
            }
            .alert("Oops", isPresented: $showAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(alertMessage)
            }
        }
    }

    // MARK: - Custom Field
    func customField(label: String, text: Binding<String>, placeholder: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .foregroundColor(.white)
                .font(.system(size: 14, weight: .semibold))
            TextField("", text: text)
                .placeholder(when: text.wrappedValue.isEmpty) {
                    Text(placeholder).foregroundColor(.gray)
                }
                .padding()
                .background(Color.clear)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.white.opacity(0.8), lineWidth: 1)
                )
                .foregroundColor(.white)
        }
    }

    func customSecureField(label: String, text: Binding<String>, placeholder: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .foregroundColor(.white)
                .font(.system(size: 14, weight: .semibold))
            SecureField("", text: text)
                .placeholder(when: text.wrappedValue.isEmpty) {
                    Text(placeholder).foregroundColor(.gray)
                }
                .padding()
                .background(Color.clear)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.white.opacity(0.8), lineWidth: 1)
                )
                .foregroundColor(.white)
        }
    }

    // MARK: - Sign up validation
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

        let user = User(name: name, email: email, phone: phone, password: password)
        UserManager.shared.saveUser(user)
        dismiss()
    }
}

#Preview {
    SignUpView()
}
