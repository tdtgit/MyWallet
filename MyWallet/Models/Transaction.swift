//
//  Transaction.swift
//  MyWallet
//
//  Created by Tuan Duong on 6/18/18.
//  Copyright © 2018 Anh Tuan. All rights reserved.
//

import Firebase

struct TransactionConfig {
    static let documentName = "transactions"
}

struct Transaction {
    var ID: String?
    var Name: String
    var Detail: String?
    var Amount: Int
    var WalletID: String
    var TypeID: String
    var CreateDate: Double
    var Repeat: Bool?
    
    var TypeName: String?
    var TypeSection: Int?
    
    var db: Firestore!
    
    init(ID: String? = nil,
         Name: String,
         Detail: String? = "",
         Amount: Int,
         WalletID: String,
         TypeID: String,
         TypeName: String? = "",
         TypeSection: Int? = 0,
         CreateDate: Double,
         Repeat: Bool? = false) {
        
        self.ID = ID
        self.Name = Name
        self.Detail = Detail
        self.Amount = Amount
        self.WalletID = WalletID
        self.TypeID = TypeID
        self.CreateDate = CreateDate
        self.Repeat = Repeat
        
        self.TypeName = TypeName
        self.TypeSection = TypeSection
        
        // [START setup]
        let settings = FirestoreSettings()
        
        Firestore.firestore().settings = settings
        // [END setup]
        db = Firestore.firestore()
    }
    
    func edit(tmpTransaction: Transaction, success: @escaping () -> Void){
        let WalletRef = db.collection(UserConfig.documentName).document((Auth.auth().currentUser?.uid)!).collection(WalletConfig.documentName).document(self.WalletID)
        
        db.runTransaction({ (transaction, errorPointer) -> Any? in
            let currentWallet: DocumentSnapshot
            do {
                try currentWallet = transaction.getDocument(WalletRef)
            } catch let fetchError as NSError {
                errorPointer?.pointee = fetchError
                return nil
            }
            
            let oldAmount = currentWallet.data()["startAmount"] as! Int
            let oldTransactionAmount = tmpTransaction.Amount
            if self.TypeSection == 1 {
                transaction.updateData(["startAmount": oldAmount + oldTransactionAmount - self.Amount], forDocument: WalletRef)
            } else {
                transaction.updateData(["startAmount": oldAmount - oldTransactionAmount + self.Amount], forDocument: WalletRef)
            }
            
            return nil
        }) { (object, error) in
            if let error = error {
                print("Transaction failed: \(error)")
            } else {
                let ref = self.db.collection(UserConfig.documentName).document((Auth.auth().currentUser?.uid)!).collection(TransactionConfig.documentName).document(self.ID!)
                
                ref.setData(self.dictionary) { err in
                    if let err = err {
                        print(err)
                    } else {
                        success()
                    }
                }
            }
        }
    }
    
    func add(success: @escaping () -> Void){
        let WalletRef = db.collection(UserConfig.documentName).document((Auth.auth().currentUser?.uid)!).collection(WalletConfig.documentName).document(self.WalletID)
        
        db.runTransaction({ (transaction, errorPointer) -> Any? in
            let currentWallet: DocumentSnapshot
            do {
                try currentWallet = transaction.getDocument(WalletRef)
            } catch let fetchError as NSError {
                errorPointer?.pointee = fetchError
                return nil
            }
            
            let oldAmount = currentWallet.data()["startAmount"] as! Int
            
            if self.TypeSection == 1 {
                transaction.updateData(["startAmount": oldAmount - self.Amount], forDocument: WalletRef)
            } else {
                transaction.updateData(["startAmount": oldAmount + self.Amount], forDocument: WalletRef)
            }
            
            return nil
        }) { (object, error) in
            if let error = error {
                print("Transaction failed: \(error)")
            } else {
                self.db.collection(UserConfig.documentName).document((Auth.auth().currentUser?.uid)!).collection(TransactionConfig.documentName).addDocument(data: self.dictionary) { err in
                    if let err = err {
                        print(err)
                    } else {
                        success()
                    }
                }
            }
        }
        
        
//
//        db.collection(UserConfig.documentName).document((Auth.auth().currentUser?.uid)!).collection(TransactionConfig.documentName).addDocument(data: self.dictionary) { err in
//            if let err = err {
//                print(err)
//            } else {
//                success()
//            }
//        }
    }
    
    var dictionary: [String: Any] {
        return [
            "name": self.Name,
            "detail": self.Detail ?? "",
            "amount": self.Amount,
            "wallet": self.WalletID,
            "type": self.TypeID,
            "createDate": self.CreateDate,
            "repeat": self.Repeat ?? false
        ]
    }
}
