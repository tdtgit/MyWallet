//
//  WalletViewController.swift
//  MyWallet
//
//  Created by Anh Tuan on 5/10/18.
//  Copyright © 2018 Anh Tuan. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class WalletCell: UITableViewCell {
    @IBOutlet weak var walletName: UILabel!
    @IBOutlet weak var walletDetail: UILabel!
    @IBOutlet weak var walletAmount: UILabel!
}

class WalletViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var db = Firestore.firestore()
    var Wallets = [Wallet]()
    @IBOutlet weak var WalletTableView: UITableView!
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ""
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Wallets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WalletCell", for: indexPath) as! WalletCell
        cell.walletName.text = Wallets[indexPath.row].Name
        cell.walletDetail.text = Wallets[indexPath.row].Detail
        cell.walletAmount.text = String(Wallets[indexPath.row].StartAmount!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let viewController = mainStoryboard.instantiateViewController(withIdentifier: "WalletAddViewController") as? WalletAddViewController {
            viewController.title = "Chỉnh sửa ví"
            viewController.passWalletName = Wallets[indexPath.row].Name
            viewController.passWalletDetail = Wallets[indexPath.row].Detail!
            viewController.passWalletStartAmount = String(Wallets[indexPath.row].StartAmount!)
            viewController.passWalletID = Wallets[indexPath.row].ID!
            if let navigator = navigationController {
                navigator.pushViewController(viewController, animated: true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            delete(id: Wallets[indexPath.row].ID!)
        }
    }
    
    public func populate(){
        var tempWallets = [Wallet]()
        db.collection("users").document((Auth.auth().currentUser?.uid)!).collection("wallets").getDocuments(completion: { querySnapshot, error in
            for document in querySnapshot!.documents {
                if let name = document.data()["name"] as? String, let detail = document.data()["detail"] as? String, let amount = document.data()["startAmount"] as? Int {
                    if tempWallets.contains(where: {$0.ID == document.documentID}) == false {
                        let newWallet = Wallet(ID: document.documentID, Name: name, Detail: detail, StartAmount: amount)
                        tempWallets.append(newWallet)
                    }
                }
            }
            self.Wallets = tempWallets
            self.WalletTableView.reloadData()
        })
    }
    
    func delete(id: String){
        db.collection("users").document((Auth.auth().currentUser?.uid)!).collection("wallets").document(id).delete() { (err) in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                self.populate()
                return
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        populate()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
