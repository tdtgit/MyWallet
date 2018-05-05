//
//  CategoryAddViewController.swift
//  MyWallet
//
//  Created by Anh Tuan on 4/30/18.
//  Copyright © 2018 Anh Tuan. All rights reserved.
//

import UIKit
import FirebaseFirestore

class CategoryAddViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var db = Firestore.firestore()
    
    @IBOutlet weak var typeName: UITextField!
    @IBOutlet weak var typeDetail: UITextField!
    
    @IBOutlet weak var typeTableView: UITableView!
    
    var typeSelected: Int?
    
    @IBAction func add(_ sender: Any) {
        let newType = WalletType(ID: "", Name: typeName.text!, Detail: typeDetail.text, Section: typeSelected!)
        newType.save()
        self.navigationController?.popViewController(animated: true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return WalletTypeSection.count
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .none
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .checkmark
            typeSelected = indexPath.row
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = WalletTypeSection[indexPath.row]
        return cell
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let cell = typeTableView.cellForRow(at: IndexPath(row: 0, section: 0)) {
            cell.accessoryType = .checkmark
        }
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
