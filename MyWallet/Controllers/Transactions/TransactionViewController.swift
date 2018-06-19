//
//  TransactionViewController.swift
//  MyWallet
//
//  Created by Tuan Duong on 6/18/18.
//  Copyright © 2018 Anh Tuan. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class TransactionCell: UITableViewCell {
    @IBOutlet weak var transactionName: UILabel!
    @IBOutlet weak var transactionDate: UILabel!
    @IBOutlet weak var transactionAmount: UILabel!
    @IBOutlet weak var transactionTypeName: UILabel!
}

class TransactionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, backToTransactionViewFromDateRange {
    
    var db = Firestore.firestore()
    
    var Transactions = [Transaction]()
    var Wallets = [Wallet]()
    var WalletTypes = [WalletType]()
    
    var dateSection = [String]()
    
    @IBOutlet weak var transactionTable: UITableView!
    @IBOutlet weak var dateRangeButton: UIBarButtonItem!
    
    var dateRangeData = -1
    
    @IBAction func displayDateRangePopup(_ sender: Any) {
        let dateRangePopupView = mainStoryboard.instantiateViewController(withIdentifier: "dateRangeTransactionPopup") as! DateRangeViewController
        dateRangePopupView.delegate = self
        dateRangePopupView.dateRangeData = dateRangeData
        dateRangePopupView.modalPresentationStyle = .overCurrentContext
        self.present(dateRangePopupView, animated: true, completion: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Transactions.count > 0 ? dateSection.count : 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Transactions.count > 0 ? dateSection[section] : "Không có dữ liệu"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Transactions.filter({ TimestampToDate(time: $0.CreateDate, format: "dd/MM/yyyy") == dateSection[section] }).count
//        return Transactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionCell", for: indexPath) as! TransactionCell
        let tmpTransaction = Transactions.filter({ TimestampToDate(time: $0.CreateDate, format: "dd/MM/yyyy") == dateSection[indexPath.section] })[indexPath.row]
        cell.transactionName.text = tmpTransaction.Name
        cell.transactionDate.text = TimestampToDate(time: tmpTransaction.CreateDate, format: "HH:mm")
        cell.transactionTypeName.text = tmpTransaction.TypeName
        cell.transactionAmount.text = moneyFormat.formattedText(from: String(tmpTransaction.Amount))
        cell.transactionAmount.textColor = tmpTransaction.TypeSection == 1 ? AppColor.Money.outcome : AppColor.Money.income
        return cell
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
        let sv = UIViewController.start(onView: self.view)
        var tempTransactions = [Transaction]()
        db.collection(UserConfig.documentName).document((Auth.auth().currentUser?.uid)!).collection(TransactionConfig.documentName).order(by: "createDate", descending: true).getDocuments(completion: { querySnapshot, error in
            for document in querySnapshot!.documents {
                if  let name = document.data()["name"] as? String,
                    let detail = document.data()["detail"] as? String,
                    let amount = document.data()["amount"] as? Double,
                    let typeID = document.data()["type"] as? String,
                    let walletID = document.data()["wallet"] as? String,
                    let createDate = document.data()["createDate"] as? Double {
                    if tempTransactions.contains(where: {$0.ID == document.documentID}) == false {
                        let newType = Transaction(
                            ID: document.documentID,
                            Name: name,
                            Detail: detail,
                            Amount: Int(amount),
                            WalletID: walletID,
                            TypeID: typeID,
                            TypeName: self.WalletTypes.filter({ $0.ID == typeID })[0].Name,
                            TypeSection: self.WalletTypes.filter({ $0.ID == typeID })[0].Section,
                            CreateDate: createDate,
                            Repeat: true)
                        tempTransactions.append(newType)
                        
                        let dateRange: String = TimestampToDate(time: createDate, format: "dd/MM/yyyy")
                        if self.dateSection.contains(where: {$0 == dateRange}) == false {
                            self.dateSection.append(dateRange)
                        }
                    }
                }
            }
            self.dateSection.sort(by: {$0 > $1 })
            self.Transactions = tempTransactions
            self.transactionTable.reloadData()
            UIViewController.stop(spinner: sv)
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        dateSection = []
        populateWalletType()
        populateWallet()
        populate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func backFromDateRange(select: Int, rangeArr: Array<Any>) {
        dateRangeData = select
        dateRangeButton.title = rangeArr[select] as? String
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
