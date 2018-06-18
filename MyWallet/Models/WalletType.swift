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

struct WalletTypeConfig {
    static let documentName = "types"
}

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
    
    func add(success: @escaping () -> Void){
        db = Firestore.firestore()
        let ref = db.collection(UserConfig.documentName).document((Auth.auth().currentUser?.uid)!).collection(WalletTypeConfig.documentName)
        
        ref.addDocument(data: self.dictionary) { err in
            if let err = err {
                print(err)
            } else {
                success()
            }
        }
    }
    
    func edit(success: @escaping () -> Void){
        db = Firestore.firestore()
        let ref = db.collection(UserConfig.documentName).document((Auth.auth().currentUser?.uid)!).collection(WalletTypeConfig.documentName).document(self.ID!)
        
        ref.setData(self.dictionary) { err in
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
            "type": self.Section,
            "createDate": NSDate().timeIntervalSince1970
        ]
    }
}
