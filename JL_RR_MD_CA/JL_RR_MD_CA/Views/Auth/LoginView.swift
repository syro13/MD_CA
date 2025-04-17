//
//  LoginView.swift
//  JL_RR_MD_CA
//
//  Created by Tanmay Bhande on 16/04/25.
//

import SwiftUI

enum AuthNavigation: Hashable {
    case dashboard
}

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var path = NavigationPath()

    @ObservedObject var userManager = UserManager.shared

    var body: some View {
        NavigationStack(path: $path) {
            VStack(spacing: 20) {
                Text("Login")
                    .font(.largeTitle)
                    .bold()

                TextField("Email", text: $email)
                    .autocapitalization(.none)
                    .textFieldStyle(.roundedBorder)

                SecureField("Password", text: $password)
                    .textFieldStyle(.roundedBorder)

                Button("Login") {
                    login()
                }
                .buttonStyle(.borderedProminent)

                Button("Login with Face ID / Touch ID") {
                    userManager.authenticateWithBiometrics { success in
                        if success {
                            path.append(AuthNavigation.dashboard)
                        } else {
                            alertMessage = "Biometric login failed"
                            showAlert = true
                        }
                    }
                }

                // Link to SignUpView (optional, just for completeness)
                NavigationLink("Don't have an account? Sign Up", destination: SignUpView())
                    .padding(.top)
            }
            .padding()
            .alert("Oops", isPresented: $showAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(alertMessage)
            }
            .navigationDestination(for: AuthNavigation.self) { route in
                switch route {
                case .dashboard:
                    Dashboard()
                }
            }
        }
    }

    func login() {
        let isValid = userManager.validate(email: email, password: password)
        if isValid {
            path.append(AuthNavigation.dashboard)
        } else {
            alertMessage = "Invalid credentials"
            showAlert = true
        }
    }
}

