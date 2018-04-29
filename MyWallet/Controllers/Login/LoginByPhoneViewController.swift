//
//  LoginByPhoneViewController.swift
//  MyWallet
//
//  Created by Anh Tuan on 4/30/18.
//  Copyright © 2018 Anh Tuan. All rights reserved.
//

import UIKit

class LoginByPhoneViewController: UIViewController {
    
    @IBOutlet weak var btnLogin: UIButton!
    
    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = AppColor.Primary.Dark
        btnLogin.layer.backgroundColor = AppColor.Primary.Light.cgColor
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
