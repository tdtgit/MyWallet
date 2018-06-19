//
//  DateRangeViewController.swift
//  MyWallet
//
//  Created by Tuan Duong on 6/18/18.
//  Copyright © 2018 Anh Tuan. All rights reserved.
//

import UIKit

protocol backToTransactionViewFromDateRange {
    func backFromDateRange(select: Int, rangeArr: Array<Any>)
}

class DateRangeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var delegate: backToTransactionViewFromDateRange? = nil
    
    let dateRange = ["Tuần này", "Tháng này", "Quý này", "Năm này"]
    var dateRangeData = -1

    @IBOutlet weak var popupView: UIView!
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        for row in 0..<tableView.numberOfRows(inSection: 0) {
            if let cell = tableView.cellForRow(at: IndexPath(row: row, section: indexPath.section)) {
                cell.accessoryType = row == indexPath.row ? .checkmark : .none
                dateRangeData = indexPath.row
                self.delegate?.backFromDateRange(select: dateRangeData, rangeArr: dateRange)
                dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = dateRange[indexPath.row]
        if dateRangeData == indexPath.row {
            cell.accessoryType = .checkmark
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dateRange.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Chọn khoản thời gian"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if dateRangeData == -1 {
            dateRangeData = 0
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
