//
//  KeychainHelper.swift
//  JL_RR_MD_CA
//
//  Created by Tanmay Bhande on 24/04/25.
//


import Foundation
import Security

class KeychainHelper {
    static func save(_ data: Data, service: String, account: String) {
        let query = [
            kSecValueData: data,
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecClass: kSecClassGenericPassword
        ] as CFDictionary

        SecItemDelete(query)
        let status = SecItemAdd(query, nil)
        if status != errSecSuccess {
            print("Error saving to Keychain: \(status)")
        }
    }

    static func read(service: String, account: String) -> Data? {
        let query = [
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecClass: kSecClassGenericPassword,
            kSecReturnData: true
        ] as CFDictionary

        var result: AnyObject?
        SecItemCopyMatching(query, &result)
        return result as? Data
    }

    static func delete(service: String, account: String) {
        let query = [
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecClass: kSecClassGenericPassword
        ] as CFDictionary

        SecItemDelete(query)
    }
}
