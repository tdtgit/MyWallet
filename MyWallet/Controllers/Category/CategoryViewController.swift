//
//  CategoryViewController.swift
//  MyWallet
//
//  Created by Anh Tuan on 4/30/18.
//  Copyright © 2018 Anh Tuan. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore


class WalletTypeCell: UITableViewCell {
    @IBOutlet weak var Name: UILabel!
    @IBOutlet weak var Detail: UILabel!
}

class CategoryViewController: UIViewController, UITableViewDataSource {
    var db: Firestore!
    let sections = ["Danh mục thu", "Danh mục chi"]
    var WalletTypeArray: [Int: [WalletType]] = [0: [], 1: []]
    
    @IBOutlet weak var TypeTableView: UITableView!
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return WalletTypeArray.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return WalletTypeArray[0]!.count
        case 1:
            return WalletTypeArray[1]!.count
        default:
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WalletTypeCell", for: indexPath) as! WalletTypeCell
        switch indexPath.section {
        case 0:
            cell.Name.text = WalletTypeArray[0]![indexPath.row].Name
            cell.Detail.text = WalletTypeArray[0]![indexPath.row].Detail
            break
        case 1:
            cell.Name.text = WalletTypeArray[1]![indexPath.row].Name
            cell.Detail.text = WalletTypeArray[1]![indexPath.row].Detail
            break
        default:
            break
        }
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        db.collection("users").document((Auth.auth().currentUser?.uid)!).collection("types").getDocuments(completion: { querySnapshot, error in
            for document in querySnapshot!.documents {
                if let name = document.data()["name"] as? String, let detail = document.data()["detail"] as? String, let id = document.data()["type"] as? Int {
                    let newType = WalletType(ID: document.documentID, Name: name, Detail: detail)
                    self.WalletTypeArray[id]!.append(newType)
                }
            }
            print(self.WalletTypeArray)
            self.TypeTableView.reloadData()
        })
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
