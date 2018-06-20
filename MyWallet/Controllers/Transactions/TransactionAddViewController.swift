//
//  TransactionAddViewController.swift
//  MyWallet
//
//  Created by Tuan Duong on 6/17/18.
//  Copyright © 2018 Anh Tuan. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class TransactionAddViewController: UITableViewController {
        
    var passTypeName = "", passTypeID = "",
        passWalletName = "", passWalletID = ""
    
    // From TransVC
    var fpassTypeName = "", fpassTypeID = "",
    fpassWalletName = "", fpassWalletID = ""
    
    var passTransaction: Transaction? = nil
    
    var WalletTypes = [WalletType]()
    var db = Firestore.firestore()
    
    let datePickerView = UIDatePicker()
    @IBOutlet weak var repeatMonthly: UISwitch!
    
    @IBOutlet weak var TransactionName: UITextField!
    @IBOutlet weak var datePicker: UITextField!
    @IBOutlet weak var amountOfMoney: UITextField!
    @IBOutlet weak var TransactionDetail: UITextField!
    
    @IBAction func submit(_ sender: Any) {
        let sv = UIViewController.start(onView: self.view)
        if fpassWalletID.isEmpty && fpassTypeID.isEmpty {
            let newTransaction = Transaction(ID: nil, Name: TransactionName.text!, Detail: TransactionDetail.text, Amount: Int(amountOfMoney.text!)!, WalletID: passWalletID, TypeID: passTypeID,
                                             TypeSection: WalletTypes.first(where: { $0.ID == passTypeID })?.Section,
                                             CreateDate: self.datePickerView.date.timeIntervalSince1970, Repeat: repeatMonthly.isOn)
            newTransaction.add {
                UIViewController.stop(spinner: sv)
                self.navigationController?.popViewController(animated: true)
            }
        } else {
            let newTransaction = Transaction(ID: passTransaction?.ID, Name: TransactionName.text!, Detail: TransactionDetail.text, Amount: Int(amountOfMoney.text!)!, WalletID: passWalletID, TypeID: passTypeID, TypeSection: WalletTypes.first(where: { $0.ID == passTypeID })?.Section, CreateDate: self.datePickerView.date.timeIntervalSince1970, Repeat: repeatMonthly.isOn)
            newTransaction.add {
                UIViewController.stop(spinner: sv)
                self.navigationController?.popViewController(animated: true)
            }
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
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        switch indexPath.section {
        case 1:
            if !passTypeID.isEmpty {
                cell.detailTextLabel?.text = passTypeName
            } else if !fpassTypeID.isEmpty {
                cell.detailTextLabel?.text = fpassTypeName
            } else {
                cell.detailTextLabel?.text = "Chưa chọn"
            }
        case 2:
            if !passWalletID.isEmpty {
                cell.detailTextLabel?.text = passWalletName
            } else if !fpassWalletID.isEmpty {
                cell.detailTextLabel?.text = fpassWalletName
            } else {
                cell.detailTextLabel?.text = "Chưa chọn"
            }
        default:
            break
        }
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
//            if let viewController = mainStoryboard.instantiateViewController(withIdentifier: "TransactionAddTypeViewController") as? TransactionAddTypeViewController {
//                if let navigator = navigationController {
//                    navigator.pushViewController(viewController, animated: true)
//                }
//            }
        }
    }
    
    @IBAction func dateAddEditing(_ sender: UITextField) {
        datePickerView.datePickerMode = UIDatePickerMode.dateAndTime
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(self.datePickerValueChanged), for: UIControlEvents.valueChanged)
    }
    
    @objc func datePickerValueChanged(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        datePicker.text = dateFormatter.string(from: sender.date)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        populateWalletType()
        if !fpassTypeID.isEmpty && !fpassWalletID.isEmpty {
            TransactionName.text = passTransaction?.Name
            amountOfMoney.text = String((passTransaction?.Amount)!)
            datePicker.text = TimestampToDate(time: (passTransaction?.CreateDate)!, format: "dd/MM/yyyy HH:mm")
            TransactionDetail.text = passTransaction?.Detail
            repeatMonthly.isOn = (passTransaction?.Repeat)!
        }
        super.tableView.reloadData()
        if (datePicker.text?.isEmpty)! {
            self.todayPicker()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let toolBar = UIToolbar().ToolbarPicker(done: #selector(self.dismissPicker), today: #selector(self.todayPicker))
        datePicker.inputAccessoryView = toolBar
    }
    
    @objc func todayPicker() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        datePicker.text = dateFormatter.string(for: Date())
    }
    
    @objc func dismissPicker() {
        view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }



}
