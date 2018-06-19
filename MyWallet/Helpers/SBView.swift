//
//  SBView.swift
//  MyWallet
//
//  Created by Anh Tuan on 4/30/18.
//  Copyright © 2018 Anh Tuan. All rights reserved.
//

import UIKit

let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
let MainView:UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "MainViewController") as UIViewController

let loginStoryboard = UIStoryboard(name: "Login", bundle: Bundle.main)
let LoginStartView:UIViewController = loginStoryboard.instantiateViewController(withIdentifier: "LoginStartViewController") as UIViewController
