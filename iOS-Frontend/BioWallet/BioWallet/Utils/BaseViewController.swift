//
//  BaseViewController.swift
//  BioWallet
//
//  Created by Alok Sahay on 15.04.2023.
//

import Foundation
import UIKit

class BaseViewController: UIViewController {
    
         func showImportAlert() {
            let alert = UIAlertController(title: "MyWeb3Wallet", message: "", preferredStyle: .alert)
            alert.addTextField { textfied in
                textfied.placeholder = "Enter mnemonics/private Key"
            }
            let mnemonicsAction = UIAlertAction(title: "Mnemonics", style: .default) { _ in
                print("Clicked on Mnemonics Option")
                guard let mnemonics = alert.textFields?[0].text else { return }
                print(mnemonics)
            }
            let privateKeyAction = UIAlertAction(title: "Private Key", style: .default) { _ in
                print("Clicked on Private Key Wallet Option")
                guard let privateKey = alert.textFields?[0].text else { return }
                print(privateKey)
//                self.importWalletWith(privateKey: privateKey)
            }
             
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            alert.addAction(mnemonicsAction)
            alert.addAction(privateKeyAction)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        }
}
