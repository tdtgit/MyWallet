//
//  WalletTypes.swift
//  MyWallet
//
//  Created by Anh Tuan on 5/3/18.
//  Copyright © 2018 Anh Tuan. All rights reserved.
//

import FirebaseFirestore
import FirebaseAuth

var WalletTypeSection = ["Danh mục thu", "Danh mục chi", "Lãi suất"]

struct WalletType {
    var ID: String?
    var Name: String
    var Detail: String?
    var Section: Int
    var CreateDate: String
    
    init(ID: String? = nil,
        Name: String,
        Detail: String? = nil,
        Section: Int,
        CreateDate: String? = nil) {
        
        self.ID = ID
        self.Name = Name
        self.Detail = Detail
        self.Section = Section
        self.CreateDate = CreateDate ?? ""
    }
    
    func save(){
        db = Firestore.firestore()
        let ref = db.collection("users").document((Auth.auth().currentUser?.uid)!).collection("types")
        
        ref.addDocument(data: self.dictionary)
    }
    
    var dictionary: [String: Any] {
        return [
            "name": self.Name,
            "detail": self.Detail ?? "",
            "type": self.Section,
            "createDate": NSDate().timeIntervalSince1970
        ]
    }
}
