//
//  Transaction.swift
//  MyWallet
//
//  Created by Tuan Duong on 6/18/18.
//  Copyright © 2018 Anh Tuan. All rights reserved.
//

import FirebaseFirestore
import FirebaseAuth

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
    var CreateDate: String
    
    init(ID: String? = nil,
         Name: String,
         Detail: String? = "",
         Amount: Int,
         WalletID: String,
         TypeID: String,
         CreateDate: String? = nil) {
        
        self.ID = ID
        self.Name = Name
        self.Detail = Detail
        self.Amount = Amount
        self.WalletID = WalletID
        self.TypeID = TypeID
        self.CreateDate = CreateDate ?? ""
    }
    
    func edit(success: @escaping () -> Void){
        db = Firestore.firestore()
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
        db = Firestore.firestore()
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
            "amount": self.Amount ?? 0,
            "wallet": self.WalletID,
            "type": self.TypeID,
            "createDate": NSDate().timeIntervalSince1970
        ]
    }
}
