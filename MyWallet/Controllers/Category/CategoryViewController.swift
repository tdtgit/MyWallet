//
//  CategoryViewController.swift
//  MyWallet
//
//  Created by Anh Tuan on 4/30/18.
//  Copyright © 2018 Anh Tuan. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class WalletTypeCell: UITableViewCell {
    @IBOutlet weak var Name: UILabel!
    @IBOutlet weak var Detail: UILabel!
}

class CategoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var db = Firestore.firestore()
    var settings = FirestoreSettings()
    
    var WalletTypes = [WalletType]()
    
    @IBOutlet weak var TypeTableView: UITableView!
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return WalletTypeSection[section]
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return WalletTypeSection.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if WalletTypeSection.count > 0 {
            return WalletTypes.filter({$0.Section == section}).count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WalletTypeCell", for: indexPath) as! WalletTypeCell
        cell.Name.text = WalletTypes.filter({ $0.Section == indexPath[0] })[indexPath.row].Name
        cell.Detail.text = WalletTypes.filter({ $0.Section == indexPath[0] })[indexPath.row].Detail
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            delete(id: WalletTypes.filter({ $0.Section == indexPath.section})[indexPath.row].ID!)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let viewController = mainStoryboard.instantiateViewController(withIdentifier: "CategoryAddViewController") as? CategoryAddViewController {
            viewController.title = "Chỉnh sửa danh mục"
            viewController.passWalletTypeName = WalletTypes.filter({ $0.Section == indexPath.section})[indexPath.row].Name
            viewController.passWalletTypeDetail = WalletTypes.filter({ $0.Section == indexPath.section})[indexPath.row].Detail!
            viewController.passWalletTypeSection = WalletTypes.filter({ $0.Section == indexPath.section})[indexPath.row].Section
            viewController.passWalletTypeID = WalletTypes.filter({ $0.Section == indexPath.section})[indexPath.row].ID!
            
            if let navigator = navigationController {
                navigator.pushViewController(viewController, animated: true)
            }
        }
    }
    
    public func populate(){
        let sv = UIViewController.start(onView: self.view)
        var tempWalletTypes = [WalletType]()
        db.collection("users").document((Auth.auth().currentUser?.uid)!).collection("types").getDocuments(completion: { querySnapshot, error in
            for document in querySnapshot!.documents {
                if let name = document.data()["name"] as? String, let detail = document.data()["detail"] as? String, let type = document.data()["type"] as? Int {
                    if tempWalletTypes.contains(where: {$0.ID == document.documentID}) == false {
                        let newType = WalletType(ID: document.documentID, Name: name, Detail: detail, Section: type)
                        tempWalletTypes.append(newType)
                    }
                }
            }
            self.WalletTypes = tempWalletTypes
            self.TypeTableView.reloadData()
            UIViewController.stop(spinner: sv)
        })
    }
    
    func delete(id: String){
        db.collection("users").document((Auth.auth().currentUser?.uid)!).collection("types").document(id).delete() { (err) in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                self.populate()
                return
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        settings.isPersistenceEnabled = true
        db.settings = settings
        populate()
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
