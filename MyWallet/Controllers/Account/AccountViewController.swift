//
//  AccountViewController.swift
//  MyWallet
//
//  Created by Tuan Duong on 6/19/18.
//  Copyright © 2018 Anh Tuan. All rights reserved.
//

import UIKit
import FirebaseAuth

class AccountViewController: UITableViewController {
    
    @IBOutlet weak var userPhone: UILabel!
    
    @IBAction func logout(_ sender: Any) {
        try! Auth.auth().signOut()
        if let login:UIViewController = loginStoryboard.instantiateViewController(withIdentifier: "LoginStartViewController") as UIViewController {
            self.present(login, animated: true, completion: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        userPhone.text = Auth.auth().currentUser?.phoneNumber
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
