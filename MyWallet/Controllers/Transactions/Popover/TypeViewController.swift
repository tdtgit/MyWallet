//
//  TypeViewController.swift
//  MyWallet
//
//  Created by Tuan Duong on 6/22/18.
//  Copyright © 2018 Anh Tuan. All rights reserved.
//

import UIKit

protocol backToTransactionViewFromType {
    func backFromType(select: Int, typeArr: Array<Any>)
}

class TypeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var delegate: backToTransactionViewFromType? = nil
    
    let typeArray = ["Tất cả danh mục", "Thu", "Chi"]
    var typeData = -1
    
    @IBOutlet weak var popupView: UIView!
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        for row in 0..<tableView.numberOfRows(inSection: 0) {
            if let cell = tableView.cellForRow(at: IndexPath(row: row, section: indexPath.section)) {
                cell.accessoryType = row == indexPath.row ? .checkmark : .none
                typeData = indexPath.row
                self.delegate?.backFromType(select: typeData, typeArr: typeArray)
                dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = typeArray[indexPath.row]
        if typeData == indexPath.row {
            cell.accessoryType = .checkmark
        } else if typeData == -2 && indexPath.row == 0 {
            cell.accessoryType = .checkmark
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return typeArray.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Chọn loại danh mục"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if typeData == -1 {
            typeData = 0
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        popupView.layer.cornerRadius = 6
        popupView.layer.masksToBounds = true
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
