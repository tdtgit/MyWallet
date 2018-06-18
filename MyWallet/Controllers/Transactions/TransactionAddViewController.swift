//
//  TransactionAddViewController.swift
//  MyWallet
//
//  Created by Tuan Duong on 6/17/18.
//  Copyright © 2018 Anh Tuan. All rights reserved.
//

import UIKit

class TransactionAddViewController: UITableViewController {
        
    var passTypeName = "", passTypeID = "",
        passWalletName = "", passWalletID = ""
    
    @IBOutlet weak var TransactionName: UITextField!
    @IBOutlet weak var datePicker: UITextField!
    @IBOutlet weak var amountOfMoney: UITextField!
    @IBOutlet weak var TransactionDetail: UITextField!
    
    @IBAction func submit(_ sender: Any) {
        let newTransaction = Transaction(ID: nil, Name: TransactionName.text!, Detail: TransactionDetail.text, Amount: Int(amountOfMoney.text!)!, WalletID: passWalletID, TypeID: passTypeID)
        newTransaction.add {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        switch indexPath.section {
        case 1:
            if passTypeID.isEmpty {
                cell.detailTextLabel?.text = "Chưa chọn"
            } else {
                cell.detailTextLabel?.text = passTypeName
            }
        case 2:
            if passWalletID.isEmpty {
                cell.detailTextLabel?.text = "Chưa chọn"
            } else {
                cell.detailTextLabel?.text = passWalletName
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
        let datePickerView = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.dateAndTime
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(self.datePickerValueChanged), for: UIControlEvents.valueChanged)
    }
    
    @objc func datePickerValueChanged(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        datePicker.text = dateFormatter.string(from: sender.date)
    }
    
    override func viewWillAppear(_ animated: Bool) {
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
