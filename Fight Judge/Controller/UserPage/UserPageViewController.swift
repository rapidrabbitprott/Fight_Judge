//
//  UserPageViewController.swift
//  Fight Judge
//
//  Created by 森川正崇 on 2019/09/21.
//  Copyright © 2019 morikawamasataka. All rights reserved.
//

import UIKit
import NCMB
import Kingfisher
import SVProgressHUD
import SwiftDate

class UserPageViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var selectedUser: NCMBUser!
    
    var followingInfo: NCMBObject?
    var uploadedFight: UploadedFight?
    var uploadedFights = [UploadedFight]()
    
    @IBOutlet var postTableView: UITableView!
    
    @IBOutlet var userImageView: UIImageView!
    
    @IBOutlet var userDisplayNameLabel: UILabel!
    
    @IBOutlet var userIntroductionTextView: UITextView!
    
    @IBOutlet var postCountLabel: UILabel!
    
    @IBOutlet var followerCountLabel: UILabel!
    
    @IBOutlet var followingCountLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //データ・ソースメソッドをこのファイル内で処理する
        postTableView.dataSource = self
        //このセルが選択された時に処理を実行する。
        postTableView.delegate = self
        //TableViewの不要な線を消す
        postTableView.tableFooterView = UIView()
        
        //カスタムセルの登録
        let nib = UINib(nibName: "FightPredictionTableViewCell", bundle: Bundle.main)
        postTableView.register(nib, forCellReuseIdentifier: "PredictionCell")
        
        //cellの高さを固定
        postTableView.rowHeight = 143
        
        //引張って更新
        setRefreshControl()
        
        //同じ試合に関する投稿のみ読み込み
        loadTimeline()
        
        //角を丸くするコード
        userImageView.layer.cornerRadius = userImageView.bounds.width / 2.0
        userImageView.layer.masksToBounds = true
        
        
        // フォロー数の読み込み
        loadFollowingInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadTimeline()
        postTableView.reloadData()
        if let user = NCMBUser.current() {
            userDisplayNameLabel.text = user.object(forKey: "displayName") as? String
            userIntroductionTextView.text = user.object(forKey: "introduction") as? String
            self.navigationItem.title = user.userName
            
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
    //cellが押された時に画面遷移
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "toPredictionDetail", sender: nil)
        //選択状態解除
        tableView.deselectRow(at: indexPath, animated: true)
    }
    //遷移先にcellの値を渡す
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let watchPredictionDetailViewController = segue.destination as! WatchPredictionDetailViewController
        let selectedIndex = postTableView.indexPathForSelectedRow!
        let user = uploadedFights[selectedIndex.row].user
        watchPredictionDetailViewController.tagNumber = selectedIndex.row
        watchPredictionDetailViewController.userName = user.displayName!
        watchPredictionDetailViewController.predictionTitle = uploadedFights[selectedIndex.row].title
        watchPredictionDetailViewController.predictionText = uploadedFights[selectedIndex.row].prediction
        watchPredictionDetailViewController.smashCount = uploadedFights[selectedIndex.row].likeCount
        watchPredictionDetailViewController.createDate = uploadedFights[selectedIndex.row].createDate
        watchPredictionDetailViewController.userImageURL = "https://mbaas.api.nifcloud.com/2013-09-01/applications/NB9tDVZPBMUmsRJC/publicFiles/" + user.objectId
        //Smashによって画像の表示を変える
        if uploadedFights[selectedIndex.row].isLiked == true {
            watchPredictionDetailViewController.smashButtonName = "clenched-redfist-64.png"
            
        } else {
            watchPredictionDetailViewController.smashButtonName = "clenched-grayfist-64.png"
            
        }
        watchPredictionDetailViewController.uploadedPredictions = uploadedFights
        //        watchPredictionDetailViewController.fightCard = self.fightCard
        //        watchPredictionDetailViewController.fightDate = self.fightDate
        watchPredictionDetailViewController.type = uploadedFights[selectedIndex.row].type
        //        watchPredictionDetailViewController.passedPPVURL = ppvURL
        //        watchPredictionDetailViewController.passedTicketURL = ticketURL
    }
    
    //1.TableViewに表示するデータの個数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return uploadedFights.count
        
    }
    
    //2.TableViewに表示するデータの内容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //idをつけたcellの取得
        let predictionCell = tableView.dequeueReusableCell(withIdentifier: "PredictionCell") as! FightPredictionTableViewCell
        
        
        predictionCell.tag = indexPath.row
        let user = uploadedFights[indexPath.row].user
        
        predictionCell.userNameLabel.text = user.displayName
        
        let userImageUrl = "https://mbaas.api.nifcloud.com/2013-09-01/applications/NB9tDVZPBMUmsRJC/publicFiles/" + user.objectId
        let image = UIImage(named: "placeholder.jpg")
        
        //画像の表示
        predictionCell.userImageView.kf.setImage(with: URL(string: userImageUrl),placeholder: image)
        //タイトル表示
        predictionCell.titleLabel.text = uploadedFights[indexPath.row].title
        
        let date = String(uploadedFights[indexPath.row].createDate.year) + "/" + String(uploadedFights[indexPath.row].createDate.month) + "/" + String(uploadedFights[indexPath.row].createDate.day)
        //タイムスタンプ表示
        predictionCell.timestampLabel.text = date
        
        
        //試合名表示
        predictionCell.hashTagLabel.text = "# " + uploadedFights[indexPath.row].fightCard
        
        //Smashによって画像の表示を変える
        if uploadedFights[indexPath.row].isLiked == true {
            predictionCell.smashButton.setImage(UIImage(named: "clenched-redfist-64.png"), for: .normal)
            predictionCell.smashButton.tintColor = Color.red
        } else {
            predictionCell.smashButton.setImage(UIImage(named: "clenched-grayfist-64.png"), for: .normal)
            predictionCell.smashButton.tintColor = Color.gray
        }
        
        //Smashの数
        predictionCell.smashCountLabel.text = "\(uploadedFights[indexPath.row].likeCount)件"
        
        predictionCell.predictionimpressionLabel.text = "#予想"
        
        return predictionCell
    }
    
    
    
    func didTapCommentsButton(tableViewCell: UITableViewCell, button: UIButton) {
        // 選ばれた投稿を一時的に格納
        uploadedFight = uploadedFights[tableViewCell.tag]
        
        // 遷移させる(このとき、prepareForSegue関数で値を渡す)
        self.performSegue(withIdentifier: "toPredictionComments", sender: nil)
    }
    
    func loadTimeline() {
        let query = NCMBQuery(className: "UploadedFight")
        
        // 降順
        query?.order(byDescending: "createDate")
        
        // 自分の投稿だけ持ってくる
        query?.whereKey("user", equalTo: NCMBUser.current())
        
        //投稿したユーザー情報も持ってくる
        query?.includeKey("user")
        
        // オブジェクトの取得
        query?.findObjectsInBackground({ (result, error) in
            if error != nil {
                SVProgressHUD.showError(withStatus: error!.localizedDescription)
            } else {
                // 投稿を格納しておく配列を初期化(これをしないとreload時にappendで二重に追加されてしまう)
                self.uploadedFights = [UploadedFight]()
                
                for postObject in result as! [NCMBObject] {
                    // ユーザー情報をUserクラスにセット
                    let user = postObject.object(forKey: "user") as! NCMBUser
                    
                    // 退会済みユーザーの投稿を避けるため、activeがfalse以外のモノだけを表示
                    if user.object(forKey: "active") as? Bool != false {
                        // 投稿したユーザーの情報をUserモデルにまとめる)
                        let userModel = User(objectId: user.objectId, userName: user.userName)
                        userModel.displayName = user.object(forKey: "displayName") as? String
                        
                        // 投稿の情報を取得
                        let title = postObject.object(forKey: "title") as! String
                        let prediction = postObject.object(forKey: "text") as! String
                        let fightCard = postObject.object(forKey: "fightCard") as! String
                        let fightDate = postObject.object(forKey: "fightDate") as! String
                        let userName = postObject.object(forKey: "userName") as! String
                        let userObjectId = postObject.object(forKey: "userObjectId") as! String
                        let type = postObject.object(forKey: "type") as! String
                        
                        // 2つのデータ(投稿情報と誰が投稿したか?)を合わせてUploadedFightクラスにセット
                        let uploadedFightPrediction = UploadedFight(objectId: postObject.objectId, user: userModel, fightCard: fightCard, fightDate: fightDate, prediction: prediction, title: title, userName: userName, userObjectId: userObjectId, createDate: postObject.createDate, type: type)
                        
                        // likeの状況(自分が過去にLikeしているか？)によってデータを挿入
                        let likeUsers = postObject.object(forKey: "likeUser") as? [String]
                        if likeUsers?.contains(NCMBUser.current().objectId) == true {
                            uploadedFightPrediction.isLiked = true
                        } else {
                            uploadedFightPrediction.isLiked = false
                        }
                        
                        // いいねの件数
                        if let likes = likeUsers {
                            uploadedFightPrediction.likeCount = likes.count
                        }
                        
                        // 配列に加える
                        self.uploadedFights.append(uploadedFightPrediction)
                    }
                }
                
                // 投稿のデータが揃ったらTableViewをリロード
                self.postTableView.reloadData()
                
                // post数を表示
                self.postCountLabel.text = String(self.uploadedFights.count)
            }
        })
        
    }
    
    
    func setRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(reloadTimeline(refreshControl:)), for: .valueChanged)
        postTableView.addSubview(refreshControl)
    }
    
    @objc func reloadTimeline(refreshControl: UIRefreshControl) {
        refreshControl.beginRefreshing()
        // 更新が早すぎるので2秒遅延させる
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            refreshControl.endRefreshing()
        }
    }
    
    
    func loadFollowingInfo() {
        // フォロー中
        let followingQuery = NCMBQuery(className: "Follow")
        followingQuery?.includeKey("user")
        followingQuery?.whereKey("user", equalTo: NCMBUser.current())
        followingQuery?.countObjectsInBackground({ (count, error) in
            if error != nil {
                SVProgressHUD.showError(withStatus: error!.localizedDescription)
            } else {
                // 非同期通信後のUIの更新はメインスレッドで
                DispatchQueue.main.async {
                    self.followingCountLabel.text = String(count)
                }
            }
        })
        
        // フォロワー
        let followerQuery = NCMBQuery(className: "Follow")
        followerQuery?.includeKey("following")
        followerQuery?.whereKey("following", equalTo: NCMBUser.current())
        followerQuery?.countObjectsInBackground({ (count, error) in
            if error != nil {
                SVProgressHUD.showError(withStatus: error!.localizedDescription)
            } else {
                DispatchQueue.main.async {
                    // 非同期通信後のUIの更新はメインスレッドで
                    self.followerCountLabel.text = String(count)
                }
            }
        })
    }
    @IBAction func showMenu() {
        let alertController = UIAlertController(title: "メニュー", message: "メニューを選択して下さい", preferredStyle: .actionSheet)
        let signOutAction = UIAlertAction(title: "ログアウト", style: .default) { (action) in
            NCMBUser.logOutInBackground({ (error) in
                if error != nil {
                    print(error)
                } else {
                    //ログアウト成功時
                    let storyboard = UIStoryboard(name: "SignIn", bundle: Bundle.main)
                    let rootViewController = storyboard.instantiateViewController(withIdentifier: "RootNavigationController")
                    UIApplication.shared.keyWindow?.rootViewController = rootViewController
                    
                    //ログイン状態の保持
                    let ud = UserDefaults.standard
                    ud.set(true, forKey: "isLogin")
                    ud.synchronize()
                }
            })
        }
        
        
        let deleteAction = UIAlertAction(title: "退会", style: .default) { (action) in
            let user = NCMBUser.current()
            user?.deleteInBackground({ (error) in
                if error != nil {
                    print(error)
                } else {
                    //ログアウト成功時
                    let storyboard = UIStoryboard(name: "SignIn", bundle: Bundle.main)
                    let rootViewController = storyboard.instantiateViewController(withIdentifier: "RootNavigationController")
                    UIApplication.shared.keyWindow?.rootViewController = rootViewController
                    
                    //ログイン状態の保持
                    let ud = UserDefaults.standard
                    ud.set(true, forKey: "isLogin")
                    ud.synchronize()
                }
            })
        }
        
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel) { (action) in
            alertController.dismiss(animated: true, completion: nil)
            
        }
        
        alertController.addAction(signOutAction)
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController,animated: true,completion: nil)
    }
    
}



