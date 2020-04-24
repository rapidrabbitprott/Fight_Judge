//
//  SignUpViewController.swift
//  Fight Judge
//
//  Created by 森川正崇 on 2019/09/18.
//  Copyright © 2019 morikawamasataka. All rights reserved.
//

import UIKit
import NCMB
import SVProgressHUD

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var userIdTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var confirmTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userIdTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        confirmTextField.delegate = self
    }
    

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func signUp() {
        let user = NCMBUser()
        
        if (userIdTextField.text?.count)! < 4 {
            let alert = UIAlertController(title: "警告", message: "文字数が足りません", preferredStyle:.alert)
            let action = UIAlertAction(title: "OK", style: .default) { (action) in
                //OKボタンを押した時のアクション
                alert.dismiss(animated: true, completion: nil)
            }
            
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
        
        user.userName = userIdTextField.text!
        user.mailAddress = emailTextField.text!
        
        if passwordTextField.text == confirmTextField.text {
            user.password = passwordTextField.text!
        } else {
            let alert = UIAlertController(title: "警告", message: "パスワードが一致しません", preferredStyle:.alert)
            let action = UIAlertAction(title: "OK", style: .default) { (action) in
                //OKボタンを押した時のアクション
                alert.dismiss(animated: true, completion: nil)
            }
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            }
        
        user.signUpInBackground { (error) in
            if error != nil {
                // エラーがあった場合
                SVProgressHUD.showError(withStatus: error!.localizedDescription)
            } else {
                let acl = NCMBACL()
                acl.setPublicReadAccess(true)
                acl.setWriteAccess(true, for: user)
                user.acl = acl
                user.saveEventually({ (error) in
                    if error != nil {
                        SVProgressHUD.showError(withStatus: error!.localizedDescription)
                        self.navigationController?.popViewController(animated: true)
                    } else {
                        // 登録成功
                        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                        let rootViewcontroller = storyboard.instantiateViewController(withIdentifier: "RootTabBarController")
                        // AppDelegateのコードとは違う、表示のコードの書き方
                        UIApplication.shared.keyWindow?.rootViewController = rootViewcontroller
                        // ログイン状態の保持(AppDelegateの"isLogin"の宣言より)
                        let ud = UserDefaults.standard
                        ud.set(true, forKey: "isLogin")
                        ud.synchronize()
                    }
                })
            }
        }
        }
    
    }

