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

class TransactionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, backToTransactionViewFromDateRange, backToTransactionViewFromType {
    
    var db = Firestore.firestore()
    
    var Transactions = [Transaction]()
    var Wallets = [Wallet]()
    var WalletTypes = [WalletType]()
    
    var dateSection = [String]()
    
    @IBOutlet weak var transactionTable: UITableView!
    @IBOutlet weak var dateRangeButton: UIBarButtonItem!
    @IBOutlet weak var typeButton: UIBarButtonItem!
    
    var dateRangeData = -2
    var typeData = -2 // -2 chưa chọn, -1 đã chọn nhưng tất cả
    
    @IBAction func displayTypePopup(_ sender: Any) {
        let typePopupView = mainStoryboard.instantiateViewController(withIdentifier: "typeViewTransactionPopup") as! TypeViewController
        typePopupView.delegate = self
        typePopupView.typeData = typeData
        typePopupView.modalPresentationStyle = .overCurrentContext
        self.present(typePopupView, animated: true, completion: nil)
    }
    
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            delete(id: Transactions.filter({ TimestampToDate(time: $0.CreateDate, format: "dd/MM/yyyy") == dateSection[indexPath.section] })[indexPath.row].ID!)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let viewController = mainStoryboard.instantiateViewController(withIdentifier: "TransactionAddViewController") as? TransactionAddViewController {
            let tmpTransaction = Transactions.filter({ TimestampToDate(time: $0.CreateDate, format: "dd/MM/yyyy") == dateSection[indexPath.section] })[indexPath.row]
            viewController.title = "Chỉnh sửa giao dịch"
            viewController.passTransaction = tmpTransaction
            viewController.fpassTypeName = WalletTypes.filter({$0.ID == tmpTransaction.TypeID})[0].Name
            viewController.fpassTypeID = tmpTransaction.TypeID
            viewController.fpassWalletName = Wallets.filter({$0.ID == tmpTransaction.WalletID})[0].Name
            viewController.fpassWalletID = tmpTransaction.WalletID
            if let navigator = navigationController {
                navigator.pushViewController(viewController, animated: true)
            }
        }
    }
    
    func delete(id: String){
        let sv = UIViewController.start(onView: self.view)
        
        let delTransaction = Transactions.filter({ $0.ID == id })[0]
        
        let WalletRef = db.collection(UserConfig.documentName).document((Auth.auth().currentUser?.uid)!).collection(WalletConfig.documentName).document(delTransaction.WalletID)
        
        db.runTransaction({ (transaction, errorPointer) -> Any? in
            let currentWallet: DocumentSnapshot
            do {
                try currentWallet = transaction.getDocument(WalletRef)
            } catch let fetchError as NSError {
                errorPointer?.pointee = fetchError
                return nil
            }
            
            let oldAmount = currentWallet.data()["startAmount"] as! Int
            
            if delTransaction.TypeSection == 1 {
                transaction.updateData(["startAmount": oldAmount + delTransaction.Amount], forDocument: WalletRef)
            } else {
                transaction.updateData(["startAmount": oldAmount - delTransaction.Amount], forDocument: WalletRef)
            }
            
            return nil
        }) { (object, error) in
            if let error = error {
                print("Transaction failed: \(error)")
            } else {
                self.db.collection(UserConfig.documentName).document((Auth.auth().currentUser?.uid)!).collection(TransactionConfig.documentName).document(id).delete() { err in
                    if let err = err {
                        print(err)
                    }
                    UIViewController.stop(spinner: sv)
                    self.populate()
                }
            }
        }
    }
    
    public func populateWalletType(){
        let sv = UIViewController.start(onView: self.view)
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
            UIViewController.stop(spinner: sv)
            self.populateWallet()
        })
    }
    
    public func populateWallet(){
        let sv = UIViewController.start(onView: self.view)
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
            UIViewController.stop(spinner: sv)
            self.populate()
        })
    }
    
    public func populate(){
        let sv = UIViewController.start(onView: self.view)
        
        var tempTransactions = [Transaction]()
        self.dateSection = []
        
        var ref = db.collection(UserConfig.documentName).document((Auth.auth().currentUser?.uid)!).collection(TransactionConfig.documentName).order(by: "createDate", descending: true)
        
        if self.dateRangeData > 0 {
            switch self.dateRangeData {
            case 1: // Week
                ref = ref.whereField("createDate", isGreaterThan: Date().startOfWeek().timeIntervalSince1970).whereField("createDate", isLessThan: Date().endOfWeek().timeIntervalSince1970)
            case 2: // Month
                ref = ref.whereField("createDate", isGreaterThan: Date().startOfMonth().timeIntervalSince1970).whereField("createDate", isLessThan: Date().endOfMonth().timeIntervalSince1970)
            case 3:
                print(Date().startOfYear().timeIntervalSince1970, Date().endOfYear().timeIntervalSince1970)
            default: ()
            }
        }
        
        ref.getDocuments(completion: { querySnapshot, error in
            for document in querySnapshot!.documents {
                if  let name = document.data()["name"] as? String,
                    let detail = document.data()["detail"] as? String,
                    let amount = document.data()["amount"] as? Double,
                    let typeID = document.data()["type"] as? String,
                    let walletID = document.data()["wallet"] as? String,
                    let createDate = document.data()["createDate"] as? Double,
                    let isRepeat = document.data()["repeat"] as? Bool {
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
                            Repeat: isRepeat)

                        tempTransactions.append(newType)
                    }
                }
            }

            if self.typeData > 0 {
                tempTransactions = tempTransactions.filter({ $0.TypeSection == self.typeData - 1 })
            }
            
            for transaction in tempTransactions {
                let dateRange: String = TimestampToDate(time: transaction.CreateDate, format: "dd/MM/yyyy")
                if self.dateSection.contains(where: {$0 == dateRange}) == false {
                    self.dateSection.append(dateRange)
                }
            }
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            self.dateSection = self.dateSection.sorted(by: { dateFormatter.date(from:$0)?.compare(dateFormatter.date(from:$1)!) == .orderedDescending })

            self.Transactions = tempTransactions
            self.transactionTable.reloadData()
            UIViewController.stop(spinner: sv)
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        populateWalletType()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func backFromDateRange(select: Int, rangeArr: Array<Any>) {
        dateRangeData = select
        dateRangeButton.title = rangeArr[select] as? String
        populate()
    }
    
    func backFromType(select: Int, typeArr: Array<Any>) {
        typeData = select
        typeButton.title = typeArr[select] as? String
        populate()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
