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
            ZStack {
                // Background Image
                VStack{
                    Image("bread1")
                        .ignoresSafeArea(.all)
                    Spacer()
                }
                // Dark Card
                VStack() {
                    Spacer()
                    VStack {
                        Text("Login to continue")
                            .font(.title.bold())
                            .foregroundColor(.yellow)
                            .padding(.bottom,20)
                        
                        // Email
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Email")
                                .foregroundColor(.white)
                                .font(.system(size: 14, weight: .semibold))
                            TextField("", text: $email)
                                .placeholder(when: email.isEmpty) {
                                    Text("Enter your email")
                                        .foregroundColor(.gray)
                                }
                                .padding()
                                .background(Color.clear)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.white.opacity(0.8), lineWidth: 1)
                                )
                                .foregroundColor(.white)
                                .padding(.bottom, 10)
                            
                        }
                        
                        // Password
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Password")
                                .foregroundColor(.white)
                                .font(.system(size: 14, weight: .semibold))
                            SecureField("", text: $password)
                                .placeholder(when: email.isEmpty) {
                                    Text("Enter your password")
                                        .foregroundColor(.gray)
                                }
                                .padding()
                                .background(Color.clear)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.white.opacity(0.8), lineWidth: 1)
                                )
                                .foregroundColor(.white)
                                .padding(.bottom, 10)
                        }
                        
                        // Remember Me (Optional)
                        HStack {
                            Image(systemName: "square")
                            Text("Remember me")
                            Spacer()
                        }
                        .foregroundColor(.gray)
                        .padding(.vertical, 20)
                        
                        // Login Button (Figma style)
                        Button(action: {
                            login()
                        }) {
                            Text("Login")
                                .frame(maxWidth: .infinity)
                                .frame(height: 55)
                                .background(Color.yellow)
                                .foregroundColor(Color(red: 40/255, green: 39/255, blue: 39/255))
                                .font(.system(size: 18, weight: .regular))
                                .cornerRadius(40)
                        }
                        
                        
                        // Biometric login
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
                        .foregroundColor(.yellow)
                        .padding()
                        HStack(spacing: 4) {
                            Text("Don't have an account?")
                                .foregroundColor(.gray)
                                .font(.system(size: 18))
                            NavigationLink("Sign Up", destination: SignUpView())
                                .foregroundColor(.yellow)
                                .font(.system(size: 18, weight: .semibold))
                        }
                    }
                    .padding(30)
                    .padding(.bottom, 10)
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
            .navigationDestination(for: AuthNavigation.self) { route in
                switch route {
                    case .dashboard: Dashboard()
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

#Preview {
    LoginView()
}
