//
//  CumulusProViewController.swift
//  Cumulus
//
//  Created by Joseph Szafarowicz on 8/25/18.
//  Copyright © 2018 Joseph Szafarowicz. All rights reserved.
//

import UIKit
import SwiftyStoreKit

class CumulusProTableViewController: UITableViewController {
    
    @IBOutlet weak var kindTipButton: UIButton!
    @IBOutlet weak var generousTipButton: UIButton!
    @IBOutlet weak var amazingTipButton: UIButton!
    
    @IBOutlet weak var cumulusProTextViewWidth: NSLayoutConstraint!
    @IBOutlet weak var cumulusProTextViewHeight: NSLayoutConstraint!
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        weatherLoaded = true
        
        self.navigationItem.title = "Cumulus Pro"
        
        if defaults.string(forKey: "userSavedColorString") == "Mandarin" {
            self.navigationController?.navigationBar.tintColor = mandarin
        } else if defaults.string(forKey: "userSavedColorString") == "Malachite" {
            self.navigationController?.navigationBar.tintColor = malachite
        } else if defaults.string(forKey: "userSavedColorString") == "Maximum Red" {
            self.navigationController?.navigationBar.tintColor = maximumRed
        } else if defaults.string(forKey: "userSavedColorString") == "Dodger Blue" {
            self.navigationController?.navigationBar.tintColor = dodgerBlue
        } else if defaults.string(forKey: "userSavedColorString") == "Plump Purple" {
            self.navigationController?.navigationBar.tintColor = plumpPurple
        } else if defaults.string(forKey: "userSavedColorString") == "Sandstorm" {
            self.navigationController?.navigationBar.tintColor = sandstorm
        } else if defaults.string(forKey: "userSavedColorString") == "Asteroid" {
            self.navigationController?.navigationBar.tintColor = asteroid
        } else if defaults.string(forKey: "userSavedColorString") == "Carmine Pink" {
            self.navigationController?.navigationBar.tintColor = carminePink
        } else {
            self.navigationController?.navigationBar.tintColor = dodgerBlue
        }
        
        let screenSize = UIScreen.main.bounds
        let screenHeight = screenSize.height
        if screenHeight == 568 {
            cumulusProTextViewWidth.constant = 300
            cumulusProTextViewHeight.constant = 143
        }
        
        self.kindTipButton.setTitle("Kind tip of $1.99", for: .normal)
        self.kindTipButton.titleLabel?.textAlignment = NSTextAlignment.center
        
        self.generousTipButton.setTitle("Generous tip of $3.99", for: .normal)
        self.generousTipButton.titleLabel?.textAlignment = NSTextAlignment.center
        

        self.amazingTipButton.setTitle("Amazing tip of $5.99", for: .normal)
        self.amazingTipButton.titleLabel?.textAlignment = NSTextAlignment.center

        kindTipButton.setBackgroundImage(UIImage(named: "Button \(buttonColor).pdf"), for: .normal)
        generousTipButton.setBackgroundImage(UIImage(named: "Button \(buttonColor).pdf"), for: .normal)
        amazingTipButton.setBackgroundImage(UIImage(named: "Button \(buttonColor).pdf"), for: .normal)
        
        let restoreBarButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(CumulusProTableViewController.restoreCumulusProTapped))
        setupBarButtonColor(button: restoreBarButton)
        navigationItem.rightBarButtonItem = restoreBarButton
        
        if potentialCustomer == true {
            let cancelBarButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(CumulusProTableViewController.cancelCumulusProTapped))
            setupBarButtonColor(button: cancelBarButton)
            navigationItem.leftBarButtonItem = cancelBarButton
        }
    }

    @IBAction func kindTipButtonTapped(_ sender: UIButton) {
        SwiftyStoreKit.retrieveProductsInfo(["com.josephszafarowicz.Cumulus.ProKindTip"]) { result in
            if let product = result.retrievedProducts.first {
                let priceString = product.localizedPrice!
                print("Product: \(product.localizedDescription), price: \(priceString)")
            }
            else if let invalidProductId = result.invalidProductIDs.first {
                print("Invalid product identifier: \(invalidProductId)")
            }
            else {
                print("Error: \(String(describing: result.error))")
            }
        }
        
        SwiftyStoreKit.purchaseProduct("com.josephszafarowicz.Cumulus.ProKindTip", quantity: 1, atomically: true) { result in
            switch result {
            case .success(let purchase):
                print("Purchase Success: \(purchase.productId)")
                defaults.set(true, forKey: "cumulusPro")
            case .error(let error):
                switch error.code {
                case .unknown: print("Unknown error. Please contact support")
                case .clientInvalid: print("Not allowed to make the payment")
                case .paymentCancelled: break
                case .paymentInvalid: print("The purchase identifier was invalid")
                case .paymentNotAllowed: print("The device is not allowed to make the payment")
                case .storeProductNotAvailable: print("The product is not available in the current storefront")
                case .cloudServicePermissionDenied: print("Access to cloud service information is not allowed")
                case .cloudServiceNetworkConnectionFailed: print("Could not connect to the network")
                case .cloudServiceRevoked: print("User has revoked permission to use this cloud service")
                default: print((error as NSError).localizedDescription)
                }
            }
            if let alert = self.alertForPurchaseResult(result) {
                self.showAlert(alert)
            }
        }
    }
    
    @IBAction func generousTipButtonTapped(_ sender: UIButton) {
        SwiftyStoreKit.retrieveProductsInfo(["com.josephszafarowicz.Cumulus.ProGenerousTip"]) { result in
            if let product = result.retrievedProducts.first {
                let priceString = product.localizedPrice!
                print("Product: \(product.localizedDescription), price: \(priceString)")
            }
            else if let invalidProductId = result.invalidProductIDs.first {
                print("Invalid product identifier: \(invalidProductId)")
            }
            else {
                print("Error: \(String(describing: result.error))")
            }
        }
        
        SwiftyStoreKit.purchaseProduct("com.josephszafarowicz.Cumulus.ProGenerousTip", quantity: 1, atomically: true) { result in
            switch result {
            case .success(let purchase):
                print("Purchase Success: \(purchase.productId)")
                defaults.set(true, forKey: "cumulusPro")
            case .error(let error):
                switch error.code {
                case .unknown: print("Unknown error. Please contact support")
                case .clientInvalid: print("Not allowed to make the payment")
                case .paymentCancelled: break
                case .paymentInvalid: print("The purchase identifier was invalid")
                case .paymentNotAllowed: print("The device is not allowed to make the payment")
                case .storeProductNotAvailable: print("The product is not available in the current storefront")
                case .cloudServicePermissionDenied: print("Access to cloud service information is not allowed")
                case .cloudServiceNetworkConnectionFailed: print("Could not connect to the network")
                case .cloudServiceRevoked: print("User has revoked permission to use this cloud service")
                default: print((error as NSError).localizedDescription)
                }
            }
            if let alert = self.alertForPurchaseResult(result) {
                self.showAlert(alert)
            }
        }
    }
    
    @IBAction func amazingTipButtonTapped(_ sender: UIButton) {
        SwiftyStoreKit.retrieveProductsInfo(["com.josephszafarowicz.Cumulus.ProAmazingTip"]) { result in
            if let product = result.retrievedProducts.first {
                let priceString = product.localizedPrice!
                print("Product: \(product.localizedDescription), price: \(priceString)")
            }
            else if let invalidProductId = result.invalidProductIDs.first {
                print("Invalid product identifier: \(invalidProductId)")
            }
            else {
                print("Error: \(String(describing: result.error))")
            }
        }
        
        SwiftyStoreKit.purchaseProduct("com.josephszafarowicz.Cumulus.ProAmazingTip", quantity: 1, atomically: true) { result in
            switch result {
            case .success(let purchase):
                print("Purchase Success: \(purchase.productId)")
                defaults.set(true, forKey: "cumulusPro")
            case .error(let error):
                switch error.code {
                case .unknown: print("Unknown error. Please contact support")
                case .clientInvalid: print("Not allowed to make the payment")
                case .paymentCancelled: break
                case .paymentInvalid: print("The purchase identifier was invalid")
                case .paymentNotAllowed: print("The device is not allowed to make the payment")
                case .storeProductNotAvailable: print("The product is not available in the current storefront")
                case .cloudServicePermissionDenied: print("Access to cloud service information is not allowed")
                case .cloudServiceNetworkConnectionFailed: print("Could not connect to the network")
                case .cloudServiceRevoked: print("User has revoked permission to use this cloud service")
                default: print((error as NSError).localizedDescription)
                }
            }
            if let alert = self.alertForPurchaseResult(result) {
                self.showAlert(alert)
            }
        }
    }
    
    @IBAction func restoreCumulusProTapped(_ sender: UIBarButtonItem) {
        // Restore previous purchases
        SwiftyStoreKit.restorePurchases(atomically: true) { results in
            if results.restoreFailedPurchases.count > 0 {
                print("Restore Failed: \(results.restoreFailedPurchases)")
            }
            else if results.restoredPurchases.count > 0 {
                print("Restore Success: \(results.restoredPurchases)")
                defaults.set(true, forKey: "cumulusPro")
            }
            else {
                print("Nothing to Restore")
            }
            self.showAlert(self.alertForRestorePurchases(results))
        }
        
        // Fetch and verify receipt
        SwiftyStoreKit.fetchReceipt(forceRefresh: true) { result in
            switch result {
            case .success(let receiptData):
                let encryptedReceipt = receiptData.base64EncodedString(options: [])
                print("Fetch receipt success:\n\(encryptedReceipt)")
            case .error(let error):
                print("Fetch receipt failed: \(error)")
            }
        }
        
        let recieptValidator = AppleReceiptValidator(service: .production, sharedSecret: "\(sharedSecret)")
        SwiftyStoreKit.verifyReceipt(using: recieptValidator, forceRefresh: false) { result in
            switch result {
            case .success(let receipt):
                print("Verify receipt success: \(receipt)")
            case .error(let error):
                print("Verify receipt failed: \(error)")
            }
        }
        
        let cumulusProKindTipValidator = AppleReceiptValidator(service: .production, sharedSecret: "\(sharedSecret)")
        SwiftyStoreKit.verifyReceipt(using: cumulusProKindTipValidator) { result in
            switch result {
            case .success(let receipt):
                let productId = "com.josephszafarowicz.Cumulus.ProKindTip"
                // Verify the purchase of Consumable or NonConsumable
                let purchaseResult = SwiftyStoreKit.verifyPurchase(
                    productId: productId,
                    inReceipt: receipt)
                
                switch purchaseResult {
                case .purchased(let receiptItem):
                    print("\(productId) is purchased: \(receiptItem)")
                    defaults.set(true, forKey: "cumulusPro")
                case .notPurchased:
                    print("The user has never purchased \(productId)")
                }
            case .error(let error):
                print("Receipt verification failed: \(error)")
            }
        }
        
        let cumulusProGenerousTipValidator = AppleReceiptValidator(service: .production, sharedSecret: "\(sharedSecret)")
        SwiftyStoreKit.verifyReceipt(using: cumulusProGenerousTipValidator) { result in
            switch result {
            case .success(let receipt):
                let productId = "com.josephszafarowicz.Cumulus.ProGenerousTip"
                // Verify the purchase of Consumable or NonConsumable
                let purchaseResult = SwiftyStoreKit.verifyPurchase(
                    productId: productId,
                    inReceipt: receipt)
                
                switch purchaseResult {
                case .purchased(let receiptItem):
                    print("\(productId) is purchased: \(receiptItem)")
                    defaults.set(true, forKey: "cumulusPro")
                case .notPurchased:
                    print("The user has never purchased \(productId)")
                }
            case .error(let error):
                print("Receipt verification failed: \(error)")
            }
        }
        
        let cumulusProAmazingTipValidator = AppleReceiptValidator(service: .production, sharedSecret: "\(sharedSecret)")
        SwiftyStoreKit.verifyReceipt(using: cumulusProAmazingTipValidator) { result in
            switch result {
            case .success(let receipt):
                let productId = "com.josephszafarowicz.Cumulus.ProAmazingTip"
                // Verify the purchase of Consumable or NonConsumable
                let purchaseResult = SwiftyStoreKit.verifyPurchase(
                    productId: productId,
                    inReceipt: receipt)
                
                switch purchaseResult {
                case .purchased(let receiptItem):
                    print("\(productId) is purchased: \(receiptItem)")
                    defaults.set(true, forKey: "cumulusPro")
                case .notPurchased:
                    print("The user has never purchased \(productId)")
                }
            case .error(let error):
                print("Receipt verification failed: \(error)")
            }
        }
    }
    
    @IBAction func cancelCumulusProTapped(_ sender: UIBarButtonItem) {
        weatherLoaded = true
        potentialCustomer = true
        dismiss(animated: true, completion: nil)
    }
}

extension CumulusProTableViewController {
    func alertWithTitle(_ title: String, message: String) -> UIAlertController {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        return alert
    }
    
    func showAlert(_ alert: UIAlertController) {
        guard self.presentedViewController != nil else {
            self.present(alert, animated: true, completion: nil)
            return
        }
    }
    
    func alertForPurchaseResult(_ result: PurchaseResult) -> UIAlertController? {
        switch result {
        case .success(let purchase):
            print("Purchase Success: \(purchase.productId)")
            return nil
        case .error(let error):
            print("Purchase Failed: \(error)")
            switch error.code {
            case .unknown: return alertWithTitle("Purchase failed", message: error.localizedDescription)
            case .clientInvalid: // client is not allowed to issue the request, etc.
                return alertWithTitle("Purchase failed", message: "Not allowed to make the payment")
            case .paymentCancelled: // user cancelled the request, etc.
                return nil
            case .paymentInvalid: // purchase identifier was invalid, etc.
                return alertWithTitle("Purchase failed", message: "The purchase identifier was invalid")
            case .paymentNotAllowed: // this device is not allowed to make the payment
                return alertWithTitle("Purchase failed", message: "The device is not allowed to make the payment")
            case .storeProductNotAvailable: // Product is not available in the current storefront
                return alertWithTitle("Purchase failed", message: "The product is not available in the current storefront")
            case .cloudServicePermissionDenied: // user has not allowed access to cloud service information
                return alertWithTitle("Purchase failed", message: "Access to cloud service information is not allowed")
            case .cloudServiceNetworkConnectionFailed: // the device could not connect to the nework
                return alertWithTitle("Purchase failed", message: "Could not connect to the network")
            case .cloudServiceRevoked: // user has revoked permission to use this cloud service
                return alertWithTitle("Purchase failed", message: "Cloud service was revoked")
            case .privacyAcknowledgementRequired:
                return alertWithTitle("Purchase failed", message: "Privacy Acknowledgement required")
            case .unauthorizedRequestData:
                return alertWithTitle("Purchase failed", message: "Unauthorized data")
            case .invalidOfferIdentifier:
                return alertWithTitle("Purchase failed", message: "Invalid product identifier")
            case .invalidSignature:
                return alertWithTitle("Purchase failed", message: "Invalid signature")
            case .missingOfferParams:
                return alertWithTitle("Purchase failed", message: "Missing parameters")
            case .invalidOfferPrice:
                return alertWithTitle("Purchase failed", message: "Invalid offer price")
            @unknown default:
                return alertWithTitle("Purchase failed", message: "Uknown error")
            }
        }
    }
    
    func alertForRestorePurchases(_ results: RestoreResults) -> UIAlertController {
        
        if results.restoreFailedPurchases.count > 0 {
            print("Restore Failed: \(results.restoreFailedPurchases)")
            return alertWithTitle("Restore failed", message: "Unknown error. Please contact support")
        } else if results.restoredPurchases.count > 0 {
            print("Restore Success: \(results.restoredPurchases)")
            return alertWithTitle("Purchases Restored", message: "Previous purchases have been restored")
        } else {
            print("Nothing to Restore")
            return alertWithTitle("Nothing to restore", message: "No previous purchases were found")
        }
    }
}