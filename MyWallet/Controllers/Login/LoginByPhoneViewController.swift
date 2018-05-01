//
//  LoginByPhoneViewController.swift
//  MyWallet
//
//  Created by Anh Tuan on 4/30/18.
//  Copyright © 2018 Anh Tuan. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginByPhoneViewController: UIViewController {
    
    @IBOutlet weak var txtPhoneNumber: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    
    func LoginSuccess(){
        self.present(MainView, animated: true)
    }
    
    func showErr(err: String){
        let alertErrController = UIAlertController(title: "Xảy ra lỗi", message: err, preferredStyle: UIAlertControllerStyle.alert)
        alertErrController.addAction(UIKit.UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: { _ in
            self.txtPhoneNumber.becomeFirstResponder()
        }))
        self.present(alertErrController, animated: true, completion: nil)
    }
    
    @IBAction func Login(_ sender: Any) {
        if txtPhoneNumber.text != "" {
            PhoneAuthProvider.provider().verifyPhoneNumber(txtPhoneNumber.text!, uiDelegate: nil){ (verificationID, error) in
                if let error = error {
                    self.showErr(err: error.localizedDescription)
                    print("Lỗi", error.localizedDescription)
                    return
                }
                let codeAlertController = UIAlertController(
                    title: "Nhập mã xác nhận",
                    message: "Vui lòng đợi mã xác nhận gồm 6 số, nhập vào ô bên dưới và nhấp Tiếp tục",
                    preferredStyle: .alert )
                codeAlertController.addTextField { textfield in
                    textfield.placeholder = "Mã xác nhận"
                    textfield.keyboardType = UIKeyboardType.numberPad
                }
                codeAlertController.addAction(
                    UIAlertAction(
                        title: "Tiếp tục",
                        style: .default,
                        handler: { (UIAlertAction) in
                            if let code = codeAlertController.textFields!.first!.text! as String?, code != "" {
                                let credential = PhoneAuthProvider.provider().credential(
                                    withVerificationID: verificationID!,
                                    verificationCode: code
                                )
                                Auth.auth().signIn(with: credential) { (user, error) in
                                    if let error = error {
                                        self.showErr(err: error.localizedDescription)
                                        return
                                    }
                                    // Success login
                                    self.LoginSuccess()
                                    
                                    let user = User(id: (Auth.auth().currentUser?.uid)!, phone: self.txtPhoneNumber.text!)
                                    user.exist(completion: { success in
                                        if success {
                                        } else {
                                            user.new()
                                        }
                                    })
                                }
                            }
                        }
                    )
                )
                self.present(codeAlertController, animated: true, completion: nil)
            }
        } else {
            showErr(err: "Vui lòng nhập số điện thoại")
        }
    }
    
    
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
