//
//  PredictViewController.swift
//  MyWallet
//
//  Created by Tuan Duong on 6/19/18.
//  Copyright © 2018 Anh Tuan. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class BigPredictCell: UITableViewCell {
    @IBOutlet weak var TypeLabel: UILabel!
    @IBOutlet weak var TypeAmount: UILabel!
}

class PredictViewController: UITableViewController {
    
    var db = Firestore.firestore()
    
    var Transactions = [Transaction]()
    var Wallets = [Wallet]()
    var WalletTypes = [WalletType]()
    
    var Header = ["Danh mục thu", "Danh mục chi", "Danh mục lãi suất"]
    var HeaderAmount = [String]()
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return Header.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        
        for type in WalletTypes.filter({ $0.Section == section }) {
            count = count + Transactions.filter({ $0.TypeID == type.ID }).count
        }
        
        return count + 1
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            switch indexPath.section {
            case 0:
                cell.contentView.backgroundColor = AppColor.Money.income
            case 1:
                cell.contentView.backgroundColor = AppColor.Money.outcome
            default:
                cell.contentView.backgroundColor = UIColor.gray
            }
            cell.separatorInset = .zero
            cell.selectionStyle = .none
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 120
        } else {
            return 44
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BigPredictCell", for: indexPath) as! BigPredictCell
            
            cell.TypeLabel.text = Header[indexPath.section]
            cell.TypeLabel.textColor = UIColor(red: 255, green: 255, blue: 255, alpha: 1)
            
            var tmpAmount = 0
            for transaction in Transactions.filter({ $0.TypeSection == indexPath.section }) {
                tmpAmount = tmpAmount + transaction.Amount
            }
            switch indexPath.section {
            case 1:
                cell.TypeAmount.text = moneyFormat.formattedText(from: String("-\(tmpAmount)"))
            default:
                cell.TypeAmount.text = moneyFormat.formattedText(from: String("+\(tmpAmount)"))
            }
            cell.TypeAmount.textColor = UIColor(red: 255, green: 255, blue: 255, alpha: 1)
            
            return cell
        } else {
            let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
            cell.textLabel?.text = Transactions.filter({ $0.TypeSection == indexPath.section })[indexPath.row - 1].Name
            cell.detailTextLabel?.text = moneyFormat.formattedText(from: String(Transactions.filter({ $0.TypeSection == indexPath.section })[indexPath.row - 1].Amount))
            return cell
        }
    }
    
    public func populateWalletType(){
        var tempWalletTypes = [WalletType]()
        db.collection(UserConfig.documentName).document((Auth.auth().currentUser?.uid)!).collection(WalletTypeConfig.documentName).getDocuments(completion: { querySnapshot, error in
            for document in querySnapshot!.documents {
                if let name = document.data()["name"] as? String, let detail = document.data()["detail"] as? String, let type = document.data()["type"] as? Int {
                    if tempWalletTypes.contains(where: {$0.ID == document.documentID}) == false {
                        let newType = WalletType(ID: document.documentID, Name: name, Detail: detail, Section: type)
                        tempWalletTypes.append(newType)
                    }
                }
            }
            self.WalletTypes = tempWalletTypes
        })
    }
    
    public func populateWallet(){
        var tempWallets = [Wallet]()
        db.collection(UserConfig.documentName).document((Auth.auth().currentUser?.uid)!).collection(WalletConfig.documentName).getDocuments(completion: { querySnapshot, error in
            for document in querySnapshot!.documents {
                if let name = document.data()["name"] as? String, let detail = document.data()["detail"] as? String, let amount = document.data()["startAmount"] as? Int {
                    if tempWallets.contains(where: {$0.ID == document.documentID}) == false {
                        let newWallet = Wallet(ID: document.documentID, Name: name, Detail: detail, StartAmount: amount)
                        tempWallets.append(newWallet)
                    }
                }
            }
            self.Wallets = tempWallets
        })
    }
    
    public func populate(){
        var tempTransactions = [Transaction]()
        db.collection(UserConfig.documentName).document((Auth.auth().currentUser?.uid)!).collection(TransactionConfig.documentName).whereField("repeat", isEqualTo: true).getDocuments(completion: { querySnapshot, error in
            for document in querySnapshot!.documents {
                if  let name = document.data()["name"] as? String,
                    let detail = document.data()["detail"] as? String,
                    let amount = document.data()["amount"] as? Double,
                    let typeID = document.data()["type"] as? String,
                    let walletID = document.data()["wallet"] as? String,
                    let createDate = document.data()["createDate"] as? Double {
                    if tempTransactions.contains(where: {$0.ID == document.documentID}) == false {
                        let newType = Transaction(ID: document.documentID,
                                                  Name: name, Detail: detail,
                                                  Amount: Int(amount),
                                                  WalletID: walletID,
                                                  TypeID: typeID,
                                                  TypeSection: self.WalletTypes.filter({ $0.ID == typeID })[0].Section,
                                                  CreateDate: createDate,
                                                  Repeat: true)
                        tempTransactions.append(newType)
                    }
                }
            }
            self.Transactions = tempTransactions
            self.tableView.reloadData()
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        populateWalletType()
        populateWallet()
        populate()
        let nextMonth = Calendar.current.date(byAdding: .month, value: 1, to: Date())?.timeIntervalSince1970
        self.title = "Dự đoán tháng " + TimestampToDate(time: nextMonth!, format: "MM/yyyy")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
