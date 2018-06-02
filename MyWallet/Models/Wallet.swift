//
//  Wallet.swift
//  MyWallet
//
//  Created by Anh Tuan on 5/10/18.
//  Copyright © 2018 Anh Tuan. All rights reserved.
//

import FirebaseFirestore
import FirebaseAuth

struct Wallet {
    var ID: String?
    var Name: String
    var Detail: String?
    var StartAmount: Int?
    var CreateDate: String
    
    init(ID: String? = nil,
         Name: String,
         Detail: String? = "",
         StartAmount: Int? = 0,
         CreateDate: String? = nil) {
        
        self.ID = ID
        self.Name = Name
        self.Detail = Detail
        self.StartAmount = StartAmount
        self.CreateDate = CreateDate ?? ""
    }
    
    func edit(){
        db = Firestore.firestore()
        let ref = db.collection("users").document((Auth.auth().currentUser?.uid)!).collection("wallets").document(self.ID!)
        
        ref.setData(self.dictionary)
    }
    
    func add(){
        db = Firestore.firestore()
        let ref = db.collection("users").document((Auth.auth().currentUser?.uid)!).collection("wallets")
        
        ref.addDocument(data: self.dictionary)
    }
    
    var dictionary: [String: Any] {
        return [
            "name": self.Name,
            "detail": self.Detail ?? "",
            "startAmount": self.StartAmount ?? 0,
            "createDate": NSDate().timeIntervalSince1970
        ]
    }
}
