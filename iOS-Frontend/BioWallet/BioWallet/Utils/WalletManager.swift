//
//  WalletManager.swift
//  BioWallet
//
//  Created by Alok Sahay on 15.04.2023.
//

import Foundation
import web3swift
import Web3Core

class WalletManager {
    
    static var sharedWalletManager = WalletManager()
    var _walletAddress: String = "0x"
    var _mnemonics: String = ""
    
    func importWalletWith(privateKey: String) {
        let formattedKey = privateKey.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let dataKey = Data.fromHex(formattedKey) else {
#if DEBUG
            print("Private key not valid")
#endif
            return
        }
        do {
            let keystore =  try EthereumKeystoreV3(privateKey: dataKey, password: "")
            if let myWeb3KeyStore = keystore {
                let manager = KeystoreManager([myWeb3KeyStore])
                let address = keystore?.addresses?.first
#if DEBUG
                print("Address :::>>>>> ", address as Any)
                print("Address :::>>>>> ", manager.addresses as Any)
#endif
                if let walletAddress = manager.addresses?.first?.address {
                    self._walletAddress = walletAddress
                } else {
                    print("error creating wallet")
                }
            } else {
                print("error creating wallet")
            }
        } catch {
#if DEBUG
            print("error creating keyStore")
            print("Private key error.")
#endif
        }
    }
    
    fileprivate func createMnemonics() {
        let userDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let web3KeystoreManager = KeystoreManager.managerForPath(userDir + "/keystore")
        do {
            if web3KeystoreManager?.addresses?.count ?? 0 >= 0 {
                let tempMnemonics = try? BIP39.generateMnemonics(bitsOfEntropy: 256, language: .english)
                guard let tMnemonics = tempMnemonics else {
                    print("Unable to create wallet")
                    return
                }
                self._mnemonics = tMnemonics
                print(_mnemonics)
                
                let tempWalletAddress = try? BIP32Keystore(mnemonics: self._mnemonics, password: "", prefixPath: "m/44'/77777'/0'/0")
                guard let walletAddress = tempWalletAddress?.addresses?.first else {
                    print("Unable to create wallet")
                    return
                }
                self._walletAddress = walletAddress.address
                let privateKey = try tempWalletAddress?.UNSAFE_getPrivateKeyData(password: "", account: walletAddress)
#if DEBUG
                print(privateKey as Any, " Is the private key 🚩🚩🚩🚩")
#endif
                let keyData = try? JSONEncoder().encode(tempWalletAddress?.keystoreParams)
                FileManager.default.createFile(atPath: userDir + "/keystore" + "/key.json", contents: keyData, attributes: nil)
                
                // Save the private key to the Secure Enclave
                
                let accessControl = SecAccessControlCreateWithFlags(nil, kSecAttrAccessibleWhenUnlockedThisDeviceOnly, .privateKeyUsage, nil)!
                let privateKeyAttrs: [String: Any] = [
                    kSecAttrKeyType as String: kSecAttrKeyTypeECSECPrimeRandom,
                    kSecAttrKeyClass as String: kSecAttrKeyClassPrivate,
                    kSecAttrAccessControl as String: accessControl,
                    kSecValueData as String: privateKey!
                ]
                let savePrivateKeyStatus = SecItemAdd(privateKeyAttrs as CFDictionary, nil)
                guard savePrivateKeyStatus == errSecSuccess else {
                    print("Failed to save private key to Secure Enclave: \(savePrivateKeyStatus)")
                    return
                }
            }
        } catch {
            //error handling here
        }
    }
    
    func importWalletWith(mnemonics: String) {
        let walletAddress = try? BIP32Keystore(mnemonics: mnemonics, password: "", prefixPath: "m/44'/77777'/0'/0")
        if let publicAddress = walletAddress?.addresses?.first?.address {
            self._walletAddress = publicAddress
            print(publicAddress) //public key
        } else {
            print("error importing wallet")
        }
    }
}
