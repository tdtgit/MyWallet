//
//  WalletAddViewController.swift
//  MyWallet
//
//  Created by Anh Tuan on 6/2/18.
//  Copyright © 2018 Anh Tuan. All rights reserved.
//

import UIKit

class WalletAddViewController: UITableViewController {

    @IBOutlet weak var WalletName: UITextField!
    @IBOutlet weak var WalletDetail: UITextField!
    @IBOutlet weak var WalletAmountStart: UITextField!
    
    var passWalletName = "",
        passWalletDetail = "",
        passWalletStartAmount = "",
        passWalletID = ""
    
    @IBAction func submit(_ sender: Any) {
        if(passWalletID.isEmpty){
            let newWallet = Wallet(ID: "", Name: WalletName.text!, Detail: WalletDetail.text, StartAmount: Int(WalletAmountStart.text!))
            newWallet.add {
                self.navigationController?.popViewController(animated: true)
            }
        } else {
            let newWallet = Wallet(ID: passWalletID, Name: WalletName.text!, Detail: WalletDetail.text, StartAmount: Int(WalletAmountStart.text!))
            newWallet.edit {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if !passWalletID.isEmpty, !passWalletName.isEmpty, !passWalletStartAmount.isEmpty {
            WalletName.text = passWalletName
            WalletDetail.text = passWalletDetail
            WalletAmountStart.text = passWalletStartAmount
        }
    }
    
    override func viewDidLoad() {
//        if !passWalletName.isEmpty, !passWalletDetail.isEmpty, !passWalletStartAmount.isEmpty {
//            WalletName.text = passWalletName
//            WalletDetail.text = passWalletDetail
//            WalletAmountStart.text = passWalletStartAmount
//        }
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//
//    // MARK: - Table view data source
//
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
