//
//  UserManager.swift
//  JL_RR_MD_CA
//
//  Created by Tanmay Bhande on 16/04/25.
//

import Foundation
import LocalAuthentication

class UserManager: ObservableObject {
    static let shared = UserManager()
    private let userKey = "savedUser"

    @Published var isAuthenticated = false

    func saveUser(_ user: User) {
        if let encoded = try? JSONEncoder().encode(user) {
            UserDefaults.standard.set(encoded, forKey: userKey)
        }
    }

    func getUser() -> User? {
        if let data = UserDefaults.standard.data(forKey: userKey),
           let user = try? JSONDecoder().decode(User.self, from: data) {
            return user
        }
        return nil
    }

    func validate(email: String, password: String) -> Bool {
        guard let user = getUser() else { return false }
        return user.email == email && user.password == password
    }

    func authenticateWithBiometrics(completion: @escaping (Bool) -> Void) {
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Login using Face ID / Touch ID"
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, _ in
                DispatchQueue.main.async {
                    self.isAuthenticated = success
                    completion(success)
                }
            }
        } else {
            completion(false)
        }
    }
}

