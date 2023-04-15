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
    
    func generatePrivateKey() {

        guard let privateKey = SecKeyCreateRandomKey([
            kSecAttrKeyType: kSecAttrKeyTypeECSECPrimeRandom,
            kSecAttrKeySizeInBits: 256,
            kSecAttrTokenID: kSecAttrTokenIDSecureEnclave,
            kSecPrivateKeyAttrs: [
                kSecAttrIsPermanent: true
            ]
        ] as CFDictionary, nil) else {
            // Handle error
            fatalError("Failed to generate private key")
        }

        var error: Unmanaged<CFError>?
        guard let privateKeyData = SecKeyCopyExternalRepresentation(privateKey, &error) as Data? else {
            // Handle error
            fatalError("Failed to extract private key data")
        }

        let privateKeyHex = privateKeyData.map { String(format: "%02x", $0) }.joined()
        print(privateKeyHex) // Print the hexadecimal representation of the private key

        
    }
    
    
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

