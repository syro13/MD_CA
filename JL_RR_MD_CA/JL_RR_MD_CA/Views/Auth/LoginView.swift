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
    @Binding var path: NavigationPath

    @ObservedObject var userManager = UserManager.shared
    
    @AppStorage("isLoggedIn") private var isLoggedIn = false
    @State private var rememberMe = false

    var body: some View {
            ZStack {
                // Background Image
                VStack{
                    Image("bread")
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
                            Toggle("Remember me", isOn: $rememberMe)
                                .toggleStyle(CheckboxToggleStyle())
                                .foregroundColor(.gray)
                                .padding(.vertical, 20)
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
                            NavigationLink("Sign Up", destination: SignUpView()
                                .navigationBarHidden(true))
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
                    case .dashboard: Dashboard(path: $path)
                        .navigationBarHidden(true)
                }
            }
    }

    func login() {
        if let loadedUser = userManager.loadUser(email: email),
           loadedUser.password == password {
            
            userManager.currentUser = loadedUser
            isLoggedIn = true
            
            if rememberMe {
                let credentials = "\(email):\(password)"
                if let data = credentials.data(using: .utf8) {
                    KeychainHelper.save(data, service: "CrumbsLogin", account: "user")
                }
            }
            
            path.append(AuthNavigation.dashboard)
        } else {
            alertMessage = "Invalid credentials"
            showAlert = true
        }
    }

}

struct CheckboxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button(action: {
            configuration.isOn.toggle()
        }) {
            HStack {
                Image(systemName: configuration.isOn ? "checkmark.square.fill" : "square")
                    .foregroundColor(configuration.isOn ? .yellow : .gray)
                configuration.label
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    LoginView(path: .constant(NavigationPath()))
}
