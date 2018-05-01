//
//  Users.swift
//  MyWallet
//
//  Created by Anh Tuan on 5/1/18.
//  Copyright © 2018 Anh Tuan. All rights reserved.
//

import Firebase
import FirebaseFirestore

var db: Firestore!

struct User {
    
    let id: String
    let phone: String
    
    func exist(completion: @escaping (Bool) -> ()) {
        db = Firestore.firestore()
        let ref = db.collection("users").document(self.id)
        
        ref.getDocument { document, error in
            if (document?.exists)! {
                completion(true)
            }
            completion(false)
        }
    }
    
    func new(){
        db = Firestore.firestore()
        let ref = db.collection("users").document(self.id)
        
        ref.setData(self.dictionary)
    }
    
    var dictionary: [String: Any] {
        return [
            "phone": self.phone,
        ]
    }
    
}
