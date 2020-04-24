//
//  WritePredictionViewController.swift
//  Fight Judge
//
//  Created by 森川正崇 on 2019/09/28.
//  Copyright © 2019 morikawamasataka. All rights reserved.
//

import UIKit
import NCMB
import UITextView_Placeholder
import SVProgressHUD


class WritePredictionViewController: UIViewController,UINavigationControllerDelegate,UITextViewDelegate {
    
    //試合名
    var fightCard = ""
    //試合名,日時の受取
    var fightDate = ""
    
    
    @IBOutlet var titleTextVIew: UITextView!
    @IBOutlet var predictionTextView: UITextView!
    @IBOutlet var saveButton: UIButton!
    @IBOutlet var postButton: UIButton!
    
    
    //下書きが残っていれば表示
    override func viewDidLoad() {
        super.viewDidLoad()
        //データの読み込み
        let query = NCMBQuery(className: "FightPrediction")
        //ユーザーネーム生成
        let userName = NCMBUser.current()?.object(forKey: "userName") as? String
        //予想であることを絞り込み
        query?.whereKey("type", equalTo: "Prediction")
        //同じ日時の投稿を絞り込み
        query?.whereKey("fightDate", equalTo:fightDate)
        //同じ試合名の投稿を絞り込み
        query?.whereKey("fightCard", equalTo: fightCard)
        //同じユーザーネームの投稿を絞り込み
        query?.whereKey("userName", equalTo:userName)
        //データの読み込み
        query?.findObjectsInBackground({ (result, error) in
            if error != nil {
                print(error)
            } else {
                let text = result as? [NCMBObject]
                let title = text?.last?.object(forKey: "title") as? String
                let prediction = text?.last?.object(forKey: "prediction") as? String
                if title == nil || prediction == nil {
                    self.saveButton.isEnabled = false
                    self.postButton.isEnabled = false
                    self.titleTextVIew.delegate = self
                    self.predictionTextView.delegate = self
                    
                } else {
                    self.titleTextVIew.text = title
                    self.predictionTextView.text = prediction
                }
                
                
            }
        })
        //角丸の程度を指定
        self.saveButton.layer.cornerRadius = 10.0
        saveButton.layer.shadowColor = UIColor.black.cgColor
        saveButton.layer.shadowOpacity = 0.5 // 透明度
        saveButton.layer.shadowOffset = CGSize(width: 5, height: 5) // 距離
        saveButton.layer.shadowRadius = 10 // ぼかし量
        
        //角丸の程度を指定
        self.postButton.layer.cornerRadius = 10.0
        postButton.layer.shadowColor = UIColor.black.cgColor
        postButton.layer.shadowOpacity = 0.5 // 透明度
        postButton.layer.shadowOffset = CGSize(width: 5, height: 5) // 距離
        postButton.layer.shadowRadius = 10 // ぼかし量
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        titleTextVIew.becomeFirstResponder()
    }
    
    
    func textViewDidChange(_ textView: UITextView) {
        confirmContent()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.resignFirstResponder()
    }
    
    //下書き保存機能
    @IBAction func save() {
        
        //データの読み込み
        let query = NCMBQuery(className: "FightPrediction")
        
        //ユーザーネーム生成
        let userName = NCMBUser.current()?.object(forKey: "userName") as? String
        
        
        //同じ日時の投稿を絞り込み
        query?.whereKey("fightDate", equalTo:fightDate)
        //同じ試合名の投稿を絞り込み
        query?.whereKey("fightCard", equalTo: fightCard)
        
        //同じユーザーネームの投稿を絞り込み
        query?.whereKey("userName", equalTo:userName)
        //データがあれば更新/無ければ保存
        query?.findObjectsInBackground({ (result, error) in
            if error != nil {
                
                SVProgressHUD.dismiss()
                let alert = UIAlertController(title: "保存できません", message: error!.localizedDescription, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                    
                })
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
                
            } else {
                if  result as! [NCMBObject] != [] {
                    //データを更新
                    //データの読み込み
                    let query = NCMBQuery(className: "FightPrediction")
                    
                    //ユーザーネーム生成
                    let userName = NCMBUser.current()?.object(forKey: "userName") as? String
                    
                    //同じ日時の投稿を絞り込み
                    query?.whereKey("fightDate", equalTo:self.fightDate)
                    //同じ試合名の投稿を絞り込み
                    query?.whereKey("fightCard", equalTo: self.fightCard)
                    
                    //同じユーザーネームの投稿を絞り込み
                    query?.whereKey("userName", equalTo:userName)
                    //データの読み込み
                    query?.findObjectsInBackground({ (result, error) in
                        if error != nil {
                            SVProgressHUD.dismiss()
                            let alert = UIAlertController(title: "保存できません", message: error!.localizedDescription, preferredStyle: .alert)
                            let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                                
                            })
                            alert.addAction(okAction)
                            self.present(alert, animated: true, completion: nil)
                        } else {
                            let text = result as! [NCMBObject]
                            let textObject = text.first
                            textObject?.setObject(self.titleTextVIew.text, forKey: "title")
                            textObject?.setObject(self.predictionTextView.text, forKey: "prediction")
                           
                            textObject?.saveInBackground({ (error) in
                                if error != nil {
                                    SVProgressHUD.dismiss()
                                    let alert = UIAlertController(title: "保存できません", message: error!.localizedDescription, preferredStyle: .alert)
                                    let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                                    })
                                    alert.addAction(okAction)
                                    self.present(alert, animated: true, completion: nil)
                                    
                                } else {
                                    //保存完了のアラート
                                    let alertController = UIAlertController(title: "保存完了", message: "試合予想の保存が完了しました", preferredStyle: .alert)
                                    //OKを押したら別の画面に遷移
                                    let action = UIAlertAction(title: "OK", style: .default) { (action) in
                                        //前の画面に戻る
                                        self.navigationController?.popViewController(animated: true)
                                        
                                    }
                                    alertController.addAction(action)
                                    self.present(alertController, animated: true, completion: nil)
                                    
                                }
                            })
                        }
                    })
                    
                } else {
                    //新しいデータを保存
                    //classを生成
                    let user = NCMBUser.current()
                    let object = NCMBObject(className:"FightPrediction")
                    //ユーザー情報を追加
                    object?.setObject(user, forKey: "user")
                    //ユーザーネームとobjectId等を識別子として追加する
                    object?.setObject(user?.objectId, forKey: "userObjectId")
                    let userName = user?.object(forKey: "userName") as? String
                    object?.setObject(userName, forKey: "userName")
                    object?.setObject(self.titleTextVIew.text, forKey: "title")
                    object?.setObject(self.predictionTextView.text, forKey: "prediction")
                    //試合日時を識別子として追加する
                    object?.setObject(self.fightDate, forKey: "fightDate")
                    //試合名を識別子として追加する
                    object?.setObject(self.fightCard, forKey: "fightCard")
                    object?.setObject("prediction", forKey: "type")
                    object?.saveInBackground({ (error) in
                        if error != nil {
                            SVProgressHUD.dismiss()
                            let alert = UIAlertController(title: "保存できません", message: error!.localizedDescription, preferredStyle: .alert)
                            let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                                
                            })
                            alert.addAction(okAction)
                            self.present(alert, animated: true, completion: nil)
                        } else {
                            //保存完了のアラート
                            let alertController = UIAlertController(title: "保存完了", message: "試合予想の保存が完了しました", preferredStyle: .alert)
                            //OKを押したら別の画面に遷移
                            let action = UIAlertAction(title: "OK", style: .default) { (action) in
                                //前の画面に戻る
                                self.navigationController?.popViewController(animated: true)
                            }
                            alertController.addAction(action)
                            self.present(alertController, animated: true, completion: nil)
                            
                        }
                    })
                }
                
            }
        })
        
    }
    
    func confirmContent() {
        if titleTextVIew.text.count > 0 && predictionTextView.text.count > 0 {
            saveButton.isEnabled = true
            postButton.isEnabled = true
        } else {
            saveButton.isEnabled = false
            postButton.isEnabled = false
        }
        
    }
    
    
    
    @IBAction func upload() {
        //下書き保存とは別の投稿するためのクラスを作成&保存
        let uploadedObject = NCMBObject(className: "UploadedFight")
        //ユーザー情報を追加
        uploadedObject?.setObject(NCMBUser.current(), forKey: "user")
        //ユーザーネームを追加して識別子にする
        let userName = NCMBUser.current()?.object(forKey: "userName") as? String
        uploadedObject?.setObject(NCMBUser.current()?.objectId, forKey: "userObjectId")
        uploadedObject?.setObject(userName, forKey: "userName")
        uploadedObject?.setObject(titleTextVIew.text, forKey: "title")
        uploadedObject?.setObject(predictionTextView.text, forKey: "text")
        uploadedObject?.setObject("prediction", forKey: "type")
        //試合日時を識別子として追加する
        uploadedObject?.setObject(fightDate, forKey: "fightDate")
        //試合名を識別子として追加する
        uploadedObject?.setObject(fightCard, forKey: "fightCard")
        
        
        uploadedObject?.saveInBackground({ (error) in
            if error != nil {
                
                SVProgressHUD.dismiss()
                let alert = UIAlertController(title: "投稿できません", message: error!.localizedDescription, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                    
                })
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
                
            } else {
                //投稿完了のアラート
                let alertController = UIAlertController(title: "投稿完了", message: "試合予想の投稿が完了しました", preferredStyle: .alert)
                //OKを押したら別の画面に遷移
                let action = UIAlertAction(title: "OK", style: .default) { (action) in
                    
                    //前の画面に戻る
                    self.navigationController?.popViewController(animated: true)
                }
                alertController.addAction(action)
                //画面遷移
                self.present(alertController, animated: true, completion: nil)
            }
        })
        //下書きを削除
        //データの読み込み
        let query = NCMBQuery(className: "FightPrediction")
        //同じユーザーネームの投稿を絞り込み
        query?.whereKey("userName", equalTo:userName)
        
        //データがあったら読み込み
        if query != nil {
            query?.findObjectsInBackground({ (result, error) in
                if error != nil {
                    SVProgressHUD.dismiss()
                    let alert = UIAlertController(title: "下書きが消去できません", message: error!.localizedDescription, preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                        
                    })
                    alert.addAction(okAction)
                    self.present(alert, animated: true, completion: nil)
                    
                } else {
                    let text = result as? [NCMBObject]
                    let textObject = text?.first
                    textObject?.deleteInBackground({ (error) in
                        if error != nil {
                            print(error)
                        } else {
                            
                        }
                    })
                    
                    
                }
            })
        }
    }
    
    
}
