//
//  DateTime.swift
//  MyWallet
//
//  Created by Tuan Duong on 6/19/18.
//  Copyright © 2018 Anh Tuan. All rights reserved.
//

import UIKit

func TimestampToDate(time: Double, format: String) -> String {
    let date = Date(timeIntervalSince1970: time)
    let dateFormatter = DateFormatter()
    dateFormatter.timeZone = TimeZone(abbreviation: "GMT+7")
    dateFormatter.locale = NSLocale.current
    dateFormatter.dateFormat = format
    return dateFormatter.string(from: date)
}
