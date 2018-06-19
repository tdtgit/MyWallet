//
//  Colors.swift
//  MyWallet
//
//  Created by Anh Tuan on 4/28/18.
//  Copyright © 2018 Anh Tuan. All rights reserved.
//

import UIKit

struct AppColor {
    struct Primary {
        static let Dark = UIColor(red:0.09, green:0.63, blue:0.52, alpha:1.0)
        static let Light = UIColor(red:0.10, green:0.74, blue:0.61, alpha:1.0)
    }
    struct TextField {
        static let BorderColor = AppColor.Primary.Light
    }
    struct Money {
        static let income = UIColor(red: 22/255, green: 150/255, blue: 133/255, alpha: 1)
        static let outcome = UIColor(red: 238/255, green: 82/255, blue: 83/255, alpha: 1) // rgb(238, 82, 83)
    }
}
