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
    
    func edit(success: @escaping () -> Void){
//        db = Firestore.firestore()
        let ref = db.collection(UserConfig.documentName).document((Auth.auth().currentUser?.uid)!).collection(TransactionConfig.documentName).document(self.ID!)
        
        ref.setData(self.dictionary) { err in
            if let err = err {
                print(err)
            } else {
                success()
            }
        }
    }
    
    func add(success: @escaping () -> Void){
//        db = Firestore.firestore()
        let ref = db.collection(UserConfig.documentName).document((Auth.auth().currentUser?.uid)!).collection(TransactionConfig.documentName)
        
        ref.addDocument(data: self.dictionary) { err in
            if let err = err {
                print(err)
            } else {
                success()
            }
        }
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
