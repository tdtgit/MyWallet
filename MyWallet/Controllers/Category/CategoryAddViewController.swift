//
//  CategoryAddTest.swift
//  MyWallet
//
//  Created by Anh Tuan on 5/7/18.
//  Copyright © 2018 Anh Tuan. All rights reserved.
//

import UIKit

class CategoryAddViewController: UITableViewController {
    
    @IBOutlet var typeTable: UITableView!
    
    @IBOutlet weak var typeName: UITextField!
    @IBOutlet weak var typeDetail: UITextField!
    
    var passWalletTypeName = ""
    var passWalletTypeDetail = ""
    var passWalletTypeSection = 0
    var passWalletTypeID = ""
    
    var SelectedID = -1 // Row index
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return WalletTypeSection.count
        } else {
            return super.tableView(tableView, numberOfRowsInSection: section)
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 {
            let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
            cell.textLabel?.text = WalletTypeSection[indexPath.row]
            if !passWalletTypeID.isEmpty, indexPath.row == passWalletTypeSection {
                cell.accessoryType = .checkmark
                SelectedID = indexPath.row
            }
            return cell
        } else {
            return super.tableView(tableView, cellForRowAt: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .none
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section != 1 {
            return
        }
        for row in 0..<tableView.numberOfRows(inSection: 1) {
            if let cell = tableView.cellForRow(at: IndexPath(row: row, section: indexPath.section)) {
                cell.accessoryType = row == indexPath.row ? .checkmark : .none
                SelectedID = indexPath.row
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section != 1 {
            return
        }
        if passWalletTypeID.isEmpty {
            let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 1))
            cell?.accessoryType = .checkmark
            return
        }
    }
    
    @IBAction func submit(_ sender: Any) {
        let sv = UIViewController.start(onView: self.view)
        if passWalletTypeID.isEmpty {
            if let selection = typeTable.indexPathForSelectedRow?.row, let name = typeName.text {
                let newType = WalletType(ID: "", Name: name, Detail: typeDetail.text, Section: selection)
                newType.add {
                    self.navigationController?.popViewController(animated: true)
                    UIViewController.stop(spinner: sv)
                }
            } else {
                UIViewController.stop(spinner: sv)
                if typeName.text == "" {
                    let alertErrController = UIAlertController(title: "Xảy ra lỗi", message: "Vui lòng nhập tên danh mục thu chi", preferredStyle: UIAlertControllerStyle.alert)
                    alertErrController.addAction(
                        UIKit.UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
                    )
                    present(alertErrController, animated: true, completion: nil)
                } else if !(typeTable.indexPathForSelectedRow != nil) {
                    let alertErrController = UIAlertController(title: "Xảy ra lỗi", message: "Vui lòng chọn danh mục thu chi", preferredStyle: UIAlertControllerStyle.alert)
                    alertErrController.addAction(
                        UIKit.UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
                    )
                    present(alertErrController, animated: true, completion: nil)
                }
            }
        } else {
            let newType = WalletType(ID: passWalletTypeID, Name: typeName.text!, Detail: typeDetail.text, Section: SelectedID)
            newType.edit {
                self.navigationController?.popViewController(animated: true)
                UIViewController.stop(spinner: sv)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if !passWalletTypeID.isEmpty, !passWalletTypeName.isEmpty {
            typeName.text = passWalletTypeName
            typeDetail.text = passWalletTypeDetail
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
