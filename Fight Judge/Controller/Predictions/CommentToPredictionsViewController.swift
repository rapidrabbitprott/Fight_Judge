//
//  CommentToPredictionsViewController.swift
//  Fight Judge
//
//  Created by 森川正崇 on 2019/11/08.
//  Copyright © 2019 morikawamasataka. All rights reserved.
//

import UIKit
import NCMB
import SVProgressHUD
import Kingfisher


class CommentToPredictionsViewController: UIViewController ,UITableViewDelegate , UITableViewDataSource {
    
    //tagを受け取るための変数
    var taga: String!
    var fightcard: String!
    var fightdate: String!
    var postText: String!
    var postTitle: String!
    var postType: String!
    var commentToPredictions = [CommentToPredictions]()
    
    
    
    @IBOutlet var commentToPredictionTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        //データ・ソースメソッドをこのファイル内で処理する
        commentToPredictionTableView.dataSource = self
        //TableViewの不要な線を消す
        commentToPredictionTableView.tableFooterView = UIView()
        //cellの高さを指定
        commentToPredictionTableView.rowHeight = 85
        //引張って更新
        setRefreshControl()
        
        loadComments()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadComments()
        commentToPredictionTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentToPredictions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        let userImageView = cell.viewWithTag(1) as! UIImageView
        let userNameLabel = cell.viewWithTag(2) as! UILabel
        let commentLabel = cell.viewWithTag(3) as! UILabel
        let createDateLabel = cell.viewWithTag(4) as! UILabel
        
        // ユーザー画像を丸く
        userImageView.layer.cornerRadius = userImageView.bounds.width / 2.0
        userImageView.layer.masksToBounds = true
        
        let user = commentToPredictions[indexPath.row].user
        let userImagePath = "https://mbaas.api.nifcloud.com/2013-09-01/applications/NB9tDVZPBMUmsRJC/publicFiles/" + user.objectId
        userImageView.kf.setImage(with: URL(string: userImagePath))
        userNameLabel.text = user.displayName
        commentLabel.text = commentToPredictions[indexPath.row].text
        
        return cell
    }
    
    func loadComments() {
        let query = NCMBQuery(className: "CommentToPost")
        query?.whereKey("postId", equalTo: taga!)
        query?.whereKey("fightCard", equalTo: fightcard)
        query?.whereKey("fightDate", equalTo: fightdate)
        query?.whereKey("postType", equalTo: postType)
        query?.whereKey("postTitle", equalTo: postTitle)
        query?.whereKey("postText", equalTo: postText)
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
                    let comment = CommentToPredictions(postId: self.taga!, user: userModel, text: text, createDate: commentObject.createDate)
                    print(comment)
                    self.commentToPredictions.append(comment)
                    // テーブルをリロード
                    self.commentToPredictionTableView.reloadData()
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
            object?.setObject(self.fightcard!, forKey: "fightCard")
            object?.setObject(self.fightdate!, forKey: "fightDate")
            object?.setObject(self.taga!, forKey: "postId")
            object?.setObject(self.postType, forKey: "postType")
            object?.setObject(self.postTitle, forKey: "postTitle")
            object?.setObject(self.postText, forKey: "postText")
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
        commentToPredictionTableView.addSubview(refreshControl)
    }
    
    @objc func reloadTimeline(refreshControl: UIRefreshControl) {
        refreshControl.beginRefreshing()
        // 更新が早すぎるので2秒遅延させる
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            refreshControl.endRefreshing()
        }
    }
}
