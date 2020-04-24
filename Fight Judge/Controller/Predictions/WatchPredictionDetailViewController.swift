//
//  WatchPredictionDetailViewController.swift
//  Fight Judge
//
//  Created by 森川正崇 on 2019/11/03.
//  Copyright © 2019 morikawamasataka. All rights reserved.
//

import UIKit
import NCMB
import Kingfisher
import SVProgressHUD
import SwiftDate
import SafariServices

class WatchPredictionDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, PostDetailTableViewCellDelegate, CommentTableViewCellDelegate {
    
    
    
    
    //cellから値を受け取るための変数
    var userName: String?
    var userImageURL: String?
    var predictionTitle: String?
    var predictionText: String?
    var type: String!
    var smashCount: Int!
    var createDate: Date!
    var smashButtonName: String?
    var tagNumber: Int?
    var uploadedPredictions: [UploadedFight] = []
    var commentToPredictions = [CommentToPredictions]()
    var PostId:String!
    var fightCard: String!
    var fightDate: String!
    
    var passedPPVURL = ""
    var passedTicketURL = ""
    //smashをした時の表示に関わる変数
    var HowManyTappedSmash: Int = 0
    @IBOutlet var commentButton: UIButton!
    @IBOutlet var watchPredictionDetailTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //データ・ソースメソッドをこのファイル内で処理する
        watchPredictionDetailTableView.dataSource = self
        //このセルが選択された時に処理を実行する。
        watchPredictionDetailTableView.delegate = self
        //TableViewの不要な線を消す
        watchPredictionDetailTableView.tableFooterView = UIView()
        //TableViewの高さを動的に決める
        watchPredictionDetailTableView.rowHeight = UITableView.automaticDimension
        //カスタムセルの登録
        let nib1 = UINib(nibName: "PostDetailTableViewCell", bundle: Bundle.main)
        watchPredictionDetailTableView.register(nib1, forCellReuseIdentifier: "PostDetailTableViewCell")
        let nib2 = UINib(nibName: "CommentTableViewCell", bundle: Bundle.main)
        watchPredictionDetailTableView.register(nib2, forCellReuseIdentifier: "CommentTableViewCell")
        
        //引張って更新
        setRefreshControl()
        
        loadComments()
        
                
        //角丸の程度を指定
        self.commentButton.layer.cornerRadius = 10.0
        commentButton.layer.shadowColor = UIColor.black.cgColor
        commentButton.layer.shadowOpacity = 0.5 // 透明度
        commentButton.layer.shadowOffset = CGSize(width: 5, height: 5) // 距離
        commentButton.layer.shadowRadius = 10 // ぼかし量
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadComments()
        watchPredictionDetailTableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return commentToPredictions.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let predictionDetailCell = tableView.dequeueReusableCell(withIdentifier: "PostDetailTableViewCell") as! PostDetailTableViewCell
            predictionDetailCell.delegate = self
            predictionDetailCell.tag = indexPath.row
            predictionDetailCell.userNameLabel.text = userName
            predictionDetailCell.titleLabel.text = predictionTitle
            predictionDetailCell.predictionTextView.text = predictionText
            let height = predictionDetailCell.predictionTextView.sizeThatFits(CGSize(width: predictionDetailCell.predictionTextView.frame.size.width, height: CGFloat.greatestFiniteMagnitude)).height
            predictionDetailCell.predictionTextView.heightAnchor.constraint(equalToConstant: height).isActive = true
            let date = String(createDate.year) + "/" + String(createDate.month) + "/" + String(createDate.day)
            //タイムスタンプ表示
            predictionDetailCell.timestampLabel.text = date

            predictionDetailCell.smashCountLabel.text = "\(smashCount!)件"
            
            let image = UIImage(named: "placeholder.jpg")
            //画像の表示
            predictionDetailCell.userImageView.kf.setImage(with: URL(string: userImageURL!),placeholder: image)
            predictionDetailCell.smashButton.setImage(UIImage(named: smashButtonName!), for: .normal)
            
            if smashButtonName == "clenched-grayfist-64.png" {
                       predictionDetailCell.smashCountButton.tintColor = Color.gray
                   } else {
                        predictionDetailCell.smashCountButton.tintColor = Color.red
                   }
            return predictionDetailCell
            
        } else {
            let commentToPredictionCell = tableView.dequeueReusableCell(withIdentifier: "CommentTableViewCell") as! CommentTableViewCell
            let user = commentToPredictions[indexPath.row].user
            let userImagePath = "https://mbaas.api.nifcloud.com/2013-09-01/applications/NB9tDVZPBMUmsRJC/publicFiles/" + user.objectId
            commentToPredictionCell.userImageView.kf.setImage(with: URL(string: userImagePath))
            commentToPredictionCell.userNameLabel.text = user.displayName
            commentToPredictionCell.commentLabel.text = commentToPredictions[indexPath.row].text
            let date = String(commentToPredictions[indexPath.row].createDate.year) + "/" + String(commentToPredictions[indexPath.row].createDate.month) + "/" + String(commentToPredictions[indexPath.row].createDate.day)
            commentToPredictionCell.timestampLabel.text = date
            return commentToPredictionCell
        }
    }
    
    func loadComments() {
        let query = NCMBQuery(className: "CommentToPost")
        query?.whereKey("postId", equalTo: PostId)
        query?.whereKey("fightCard", equalTo: fightCard)
        query?.whereKey("fightDate", equalTo: fightDate)
        query?.whereKey("postType", equalTo: type)
        query?.whereKey("postTitle", equalTo: predictionTitle!)
        query?.whereKey("postText", equalTo: predictionText!)
        // 降順
        query?.order(byDescending: "createDate")
        query?.includeKey("user")
        query?.findObjectsInBackground({ (result, error) in
            if error != nil {
                SVProgressHUD.showError(withStatus: error!.localizedDescription)
            } else {
                self.commentToPredictions = [CommentToPredictions]()
                for commentObject in result as! [NCMBObject] {
                    // コメントをしたユーザーの情報を取得
                    let user = commentObject.object(forKey: "user") as! NCMBUser
                    let userModel = User(objectId: user.objectId, userName: user.userName)
                    userModel.displayName = user.object(forKey: "displayName") as? String
                    
                    // コメントの文字を取得
                    let text = commentObject.object(forKey: "text") as! String
                    
                    // Commentクラスに格納
                    let comment = CommentToPredictions(postId: String(self.tagNumber!), user: userModel, text: text, createDate: commentObject.createDate)
                    self.commentToPredictions.append(comment)
                    // テーブルをリロード
                    self.watchPredictionDetailTableView.reloadData()
                }
                
                
            }
        })
    }
    
    @IBAction func addComment() {
        let alert = UIAlertController(title: "コメント", message: "コメントを入力して下さい", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "キャンセル", style: .default) { (action) in
            alert.dismiss(animated: true, completion: nil)
        }
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            alert.dismiss(animated: true, completion: nil)
            SVProgressHUD.show()
            let object = NCMBObject(className: "CommentToPost")
            object?.setObject(self.fightCard, forKey: "fightCard")
            object?.setObject(self.fightDate, forKey: "fightDate")
            object?.setObject(self.PostId, forKey: "postId")
            object?.setObject(self.type, forKey: "postType")
            object?.setObject(self.predictionTitle, forKey: "postTitle")
            object?.setObject(self.predictionText!, forKey: "postText")
            object?.setObject(NCMBUser.current(), forKey: "user")
            object?.setObject(alert.textFields?.first?.text, forKey: "text")
            object?.saveInBackground({ (error) in
                if error != nil {
                    SVProgressHUD.showError(withStatus: error!.localizedDescription)
                } else {
                    SVProgressHUD.dismiss()
                    self.loadComments()
                }
            })
        }
        
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        alert.addTextField { (textField) in
            textField.placeholder = "ここにコメントを入力"
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    func setRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(reloadTimeline(refreshControl:)), for: .valueChanged)
        watchPredictionDetailTableView.addSubview(refreshControl)
    }
    
    @objc func reloadTimeline(refreshControl: UIRefreshControl) {
        refreshControl.beginRefreshing()
        // 更新が早すぎるので2秒遅延させる
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            refreshControl.endRefreshing()
        }
    }
    
    func smash(tableViewCell: PostDetailTableViewCell, button: UIButton) {
           if smashButtonName == "clenched-grayfist-64.png" {
               self.smashCount = self.smashCount! + 1
               tableViewCell.smashCountLabel.text = "\(self.smashCount!)件"
               self.smashButtonName = "clenched-redfist-64.png"
               tableViewCell.smashButton.setImage(UIImage(named: self.smashButtonName!), for: .normal)
               tableViewCell.smashCountButton.tintColor = Color.red
               
               let query = NCMBQuery(className: "UploadedFight")
               query?.getObjectInBackground(withId: uploadedPredictions[tagNumber!].objectId, block: { (post, error) in
                   post?.addUniqueObject(NCMBUser.current().objectId, forKey: "likeUser")
                   post?.saveEventually({ (error) in
                       if error != nil {
                           SVProgressHUD.showError(withStatus: error!.localizedDescription)
                       } else {
                           
                       }
                   })
               })
               
           } else {
               self.smashCount = self.smashCount! - 1
               tableViewCell.smashCountLabel.text = "\(self.smashCount!)件"
               self.smashButtonName = "clenched-grayfist-64.png"
               tableViewCell.smashButton.setImage(UIImage(named: self.smashButtonName!), for: .normal)
               tableViewCell.smashCountButton.tintColor = Color.gray
               
               let query = NCMBQuery(className: "UploadedFight")
               query?.getObjectInBackground(withId: uploadedPredictions[tagNumber!].objectId, block: { (post, error) in
                   if error != nil {
                       SVProgressHUD.showError(withStatus: error!.localizedDescription)
                   } else {
                       post?.removeObjects(in: [NCMBUser.current().objectId], forKey: "likeUser")
                       post?.saveEventually({ (error) in
                           if error != nil {
                               SVProgressHUD.showError(withStatus: error!.localizedDescription)
                           } else {
                               
                           }
                       })
                   }
               })
           }
       }
       
       func share(tableViewCell: PostDetailTableViewCell, button: UIButton) {
           // StringとUIImageを配列で設定
           let sharedText = predictionTitle! + ":" + predictionText!
           let activityItems: [Any] = [sharedText]
           let activityVc = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
           present(activityVc, animated: true, completion: {
           })
       }
       
       func buy(tableViewCell: PostDetailTableViewCell, button: UIButton) {
           let alertController = UIAlertController(title: "購入", message: "チケットかPPVを購入しますか?", preferredStyle: .alert)
           //OKを押したら別の画面に遷移
           let buyTicket = UIAlertAction(title: "チケット", style: .default) { (action) in
               //チケットを押したときのアクション
               self.showSafariVC(for: self.passedTicketURL)
           }
           let buyPPV = UIAlertAction(title: "PPV", style: .default) { (action) in
               //PPVを押した時のアクション
               self.showSafariVC(for: self.passedPPVURL)
           }
           let cancelAction = UIAlertAction(title: "キャンセル", style: .default) { (action) in
               alertController.dismiss(animated: true, completion: nil)
           }
           alertController.addAction(buyTicket)
           alertController.addAction(buyPPV)
           alertController.addAction(cancelAction)
           self.present(alertController, animated: true, completion: nil)
       }
       
       func reply(tableViewCell: UITableViewCell, button: UIButton) {
           print("reply")
       }
       
       func like(tableViewCell: UITableViewCell, button: UIButton) {
           print("like")
       }
       
       func dislike(tableViewCell: UITableViewCell, button: UIButton) {
           print("dislike")
       }
       
       func more(tableViewCell: UITableViewCell, button: UIButton) {
           print("more")
       }
        
    
    @IBAction func menuButton(button: UIButton) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: "削除する", style: .destructive) { (action) in
            SVProgressHUD.show()
            let query = NCMBQuery(className: "UploadedFight")
            query?.getObjectInBackground(withId: self.uploadedPredictions[self.tagNumber!].objectId, block: { (post, error) in
                if error != nil {
                    SVProgressHUD.showError(withStatus: error!.localizedDescription)
                } else {
                    // 取得した投稿オブジェクトを削除
                    post?.deleteInBackground({ (error) in
                        if error != nil {
                            SVProgressHUD.showError(withStatus: error!.localizedDescription)
                        } else {
                            // 画面を戻す
                            SVProgressHUD.showSuccess(withStatus: "この投稿を削除しました。")
                            self.navigationController?.popViewController(animated: true)
                        }
                    })
                }
            })
        }
        let reportAction = UIAlertAction(title: "報告する", style: .destructive) { (action) in
            SVProgressHUD.showSuccess(withStatus: "この投稿を報告しました。ご協力ありがとうございました。")
            self.navigationController?.popViewController(animated: true)
        }
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel) { (action) in
            alertController.dismiss(animated: true, completion: nil)
        }
        
        if uploadedPredictions[tagNumber!].user.objectId == NCMBUser.current().objectId {
            // 自分の投稿なので、削除ボタンを出す
            alertController.addAction(deleteAction)
        } else {
            // 他人の投稿なので、報告ボタンを出す
            alertController.addAction(reportAction)
        }
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func showSafariVC(for url:String) {
        guard let url = URL(string: url) else {
            //不正なURLのアラート
            let alertController = UIAlertController(title: "不正なURL", message: "URLが取得できません", preferredStyle: .alert)
            //OKを押したら別の画面に遷移
            let action = UIAlertAction(title: "OK", style: .default) { (action) in
                //前の画面に戻る
                self.navigationController?.popViewController(animated: true)
            }
            alertController.addAction(action)
            self.present(alertController, animated: true, completion: nil)
            return
            
        }
        let safariVC = SFSafariViewController(url: url)
        present(safariVC, animated: true)
        
    }
    
}
