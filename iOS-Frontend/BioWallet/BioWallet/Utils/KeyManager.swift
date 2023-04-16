//
//  KeyManager.swift
//  BioWallet
//
//  Created by Alok Sahay on 15.04.2023.
//

import Foundation
import Security

class KeyManager {

    struct KeychainKeys {
        static let accountPassKey = "com.biowallet.passkey"
    }
    
    static let sharedManager = KeyManager()
    
    func savePasskey(_ passkey: String) -> Bool {
        guard let data = passkey.data(using: String.Encoding.utf8) else {
            print("Error saving passkey to keychain.")
            return false
        }
        
        let query = [
            kSecClass as String: kSecClassGenericPassword as String,
            kSecAttrAccount as String: KeychainKeys.accountPassKey,
            kSecValueData as String: data,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlockedThisDeviceOnly
        ] as [String : Any]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        return status == errSecSuccess
    }

    func retrievePasskey() -> String? {
        let query = [
            kSecClass as String: kSecClassGenericPassword as String,
            kSecAttrAccount as String: KeychainKeys.accountPassKey,
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne
        ] as [String : Any]
        
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        if status == errSecSuccess {
            let passkeyData = dataTypeRef as! Data
            return String(data: passkeyData, encoding: String.Encoding.utf8)
        } else {
            print("Error retrieving passkey from keychain.")
            return nil
        }
    }

}

