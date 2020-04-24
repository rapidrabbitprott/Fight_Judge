//
//  EditUserPageViewController.swift
//  Fight Judge
//
//  Created by 森川正崇 on 2019/09/21.
//  Copyright © 2019 morikawamasataka. All rights reserved.
//

import UIKit
import NCMB
import NYXImagesKit

class EditUserPageViewController: UIViewController,UITextFieldDelegate,UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet var userImageView: UIImageView!
    @IBOutlet var userNameTextField: UITextField!
    @IBOutlet var userIdTextField: UITextField!
    @IBOutlet var introductionTextView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //角を丸くするコード
        userImageView.layer.cornerRadius = userImageView.bounds.width / 2.0
        userImageView.layer.masksToBounds = true
        
        userNameTextField.delegate = self
        userIdTextField.delegate = self
        introductionTextView.delegate = self
        
        let userId = NCMBUser.current()?.userName
        userIdTextField.text = userId
        
        if let user = NCMBUser.current() {
            userNameTextField.text = user.object(forKey: "displayName") as? String
            userIdTextField.text = user.userName
            introductionTextView.text = user.object(forKey: "introduction") as? String
            let file = NCMBFile.file(withName: user.objectId , data:nil) as!NCMBFile
            file.getDataInBackground { (data, error) in
                if error != nil {
                    print(error)
                } else {
                    if data != nil {
                        let image = UIImage(data: data!)
                        self.userImageView.image = image
                    }
                    
                }
            }
        } else {
            //NCMBUser.current()がnil
            //ログアウト成功時
            let storyboard = UIStoryboard(name: "SignIn", bundle: Bundle.main)
            let rootViewController = storyboard.instantiateViewController(withIdentifier: "RootNavigationController")
            UIApplication.shared.keyWindow?.rootViewController = rootViewController
            
            //ログイン状態の保持
            let ud = UserDefaults.standard
            ud.set(true, forKey: "isLogin")
            ud.synchronize()
        }
        
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        textView.resignFirstResponder()
        return true
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        let resizedImage = selectedImage.scale(byFactor: 0.4)
        
        picker.dismiss(animated: true, completion: nil)
        
        let data = resizedImage!.pngData()
        let file = NCMBFile.file(withName: NCMBUser.current()?.objectId, data: data) as! NCMBFile
        file.saveInBackground({ (error) in
            if error != nil {
                print(error)
            } else {
                self.userImageView.image = selectedImage

            }
        }) { (progress) in
            print(progress)
        }
        
        
        
    }
    
    @IBAction func selectImage() {
        let actionController = UIAlertController(title: "画像の選択", message: "選択して下さい", preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "カメラ", style: .default) { (action) in
            //カメラ起動
            if UIImagePickerController.isSourceTypeAvailable(.camera) == true {
                let picker = UIImagePickerController()
                picker.sourceType = .camera
                picker.delegate = self
                self.present(picker, animated: true, completion: nil)
            } else {
                print("この機種ではカメラは使用できません")
            }
            
            
        }
        
        let albumAction = UIAlertAction(title: "フォトライブラリ", style: .default) { (action) in
            //アルバム起動
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) == true {
                let picker = UIImagePickerController()
                picker.sourceType = .photoLibrary
                picker.delegate = self
                self.present(picker, animated: true, completion: nil)
            } else {
                print("この機種ではフォトライブラリは使えません")
            }
            
        }
        
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel) { (action) in
            //キャンセル
            actionController.dismiss(animated: true, completion: nil)
        }
        
        actionController.addAction(cameraAction)
        actionController.addAction(albumAction)
        actionController.addAction(cancelAction)
        self.present(actionController, animated: true, completion: nil)
    }
    
    @IBAction func closeEditUserPageViewController() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveUserInfo() {
        let user = NCMBUser.current()
        user?.setObject(userNameTextField.text, forKey: "displayName")
        user?.setObject(userIdTextField.text, forKey: "userName")
        user?.setObject(introductionTextView.text, forKey: "introduction")
        user?.saveInBackground({ (error) in
            if error != nil {
                print(error)
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        })
    }

}
