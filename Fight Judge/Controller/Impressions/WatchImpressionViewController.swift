//
//  WatchImpressionViewController.swift
//  Fight Judge
//
//  Created by 森川正崇 on 2019/11/10.
//  Copyright © 2019 morikawamasataka. All rights reserved.
//

import UIKit
import NCMB
import Kingfisher
import SVProgressHUD
import SwiftDate

class WatchImpressionViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {
    
    var uploadedFight: UploadedFight?
    var uploadedImpression = [UploadedFight]()
    //変数(値受け取り用含む)
    var fightCard = ""
    var fightDate = ""
    var cellNumber = 0
    
    //TableView
    @IBOutlet var impressionTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //データ・ソースメソッドをこのファイル内で処理する
        impressionTableView.dataSource = self
        //このセルが選択された時に処理を実行する。
        impressionTableView.delegate = self
        //TableViewの不要な線を消す
        impressionTableView.tableFooterView = UIView()
        
        //カスタムセルの登録
        let nib = UINib(nibName: "FightPredictionTableViewCell", bundle: Bundle.main)
        impressionTableView.register(nib, forCellReuseIdentifier: "PredictionCell")
        
        //cellの高さを固定
        impressionTableView.rowHeight = 143
        
        //引張って更新
        setRefreshControl()
        
        //同じ試合に関する投稿のみ読み込み
        loadTimeline()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        loadTimeline()
        impressionTableView.reloadData()
    }
    
    //cellが押された時に画面遷移
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "toImpressionDetail", sender: nil)
        //選択状態解除
        tableView.deselectRow(at: indexPath, animated: true)
       }
    
//    遷移先にcellの値を渡す
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let watchImpressionDetailViewController = segue.destination as! WatchPredictionDetailViewController
        let selectedIndex = impressionTableView.indexPathForSelectedRow!
        let user = uploadedImpression[selectedIndex.row].user
        watchImpressionDetailViewController.tagNumber = selectedIndex.row
        watchImpressionDetailViewController.userName = user.displayName!
        watchImpressionDetailViewController.predictionTitle = uploadedImpression[selectedIndex.row].title
        watchImpressionDetailViewController.predictionText = uploadedImpression[selectedIndex.row].prediction
        watchImpressionDetailViewController.smashCount = uploadedImpression[selectedIndex.row].likeCount
        watchImpressionDetailViewController.createDate = uploadedImpression[selectedIndex.row].createDate
        watchImpressionDetailViewController.userImageURL = "https://mbaas.api.nifcloud.com/2013-09-01/applications/NB9tDVZPBMUmsRJC/publicFiles/" + user.objectId
        //Smashによって画像の表示を変える
        if uploadedImpression[selectedIndex.row].isLiked == true {
            watchImpressionDetailViewController.smashButtonName = "clenched-redfist-64.png"
        } else {
            watchImpressionDetailViewController.smashButtonName = "clenched-grayfist-64.png"
        }
        watchImpressionDetailViewController.uploadedPredictions = uploadedImpression
        watchImpressionDetailViewController.fightCard = self.fightCard
    }
    
    //1.TableViewに表示するデータの個数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return uploadedImpression.count
        
    }
    
    //2.TableViewに表示するデータの内容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //idをつけたcellの取得
        let predictionCell = tableView.dequeueReusableCell(withIdentifier: "PredictionCell") as! FightPredictionTableViewCell
        
        
        predictionCell.tag = indexPath.row
        let user = uploadedImpression[indexPath.row].user
        
        predictionCell.userNameLabel.text = user.displayName
        
        let userImageUrl = "https://mbaas.api.nifcloud.com/2013-09-01/applications/NB9tDVZPBMUmsRJC/publicFiles/" + user.objectId
        let image = UIImage(named: "placeholder.jpg")
        
        //画像の表示
        predictionCell.userImageView.kf.setImage(with: URL(string: userImageUrl),placeholder: image)
        //タイトル表示
        predictionCell.titleLabel.text = uploadedImpression[indexPath.row].title
        //タイムスタンプ表示
        predictionCell.timestampLabel.text = uploadedImpression[indexPath.row].createDate.toString()
        //試合名表示
        predictionCell.hashTagLabel.text = "# " + uploadedImpression[indexPath.row].fightCard
        
        
        //Smashによって画像の表示を変える
        if uploadedImpression[indexPath.row].isLiked == true {
            predictionCell.smashButton.setImage(UIImage(named: "clenched-redfist-64.png"), for: .normal)
            predictionCell.smashButton.tintColor = Color.red
        } else {
            predictionCell.smashButton.setImage(UIImage(named: "clenched-grayfist-64.png"), for: .normal)
            predictionCell.smashButton.tintColor = Color.gray
        }
        
        //Smashの数
        predictionCell.smashCountLabel.text = "\(uploadedImpression[indexPath.row].likeCount)件"
        
        if uploadedImpression[indexPath.row].type == "impression" {
            predictionCell.predictionimpressionLabel.text = "#感想"
        } else {
            predictionCell.predictionimpressionLabel.text = "#予想"
        }
        
        return predictionCell
    }
    
    

    func didTapCommentsButton(tableViewCell: UITableViewCell, button: UIButton) {
        // 選ばれた投稿を一時的に格納
        uploadedFight = uploadedImpression[tableViewCell.tag]

        // 遷移させる(このとき、prepareForSegue関数で値を渡す)
        self.performSegue(withIdentifier: "toPredictionComments", sender: nil)
    }
    
    func loadTimeline() {
        let query = NCMBQuery(className: "UploadedFight")

        // 降順
        query?.order(byDescending: "createDate")

        // 同じ試合だけ持ってくる
        query?.whereKey("fightCard", equalTo: fightCard)
        query?.whereKey("fightDate", equalTo: fightDate)
        
        //投稿したユーザー情報も持ってくる
        query?.includeKey("user")

        // オブジェクトの取得
        query?.findObjectsInBackground({ (result, error) in
            if error != nil {
                SVProgressHUD.showError(withStatus: error!.localizedDescription)
            } else {
                // 投稿を格納しておく配列を初期化(これをしないとreload時にappendで二重に追加されてしまう)
                self.uploadedImpression = [UploadedFight]()

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
                        let uploadedFightImpression = UploadedFight(objectId: postObject.objectId, user: userModel, fightCard: fightCard, fightDate: fightDate, prediction: prediction, title: title, userName: userName, userObjectId: userObjectId, createDate: postObject.createDate, type: type)
                        // likeの状況(自分が過去にLikeしているか？)によってデータを挿入
                        let likeUsers = postObject.object(forKey: "likeUser") as? [String]
                        if likeUsers?.contains(NCMBUser.current().objectId) == true {
                            uploadedFightImpression.isLiked = true
                        } else {
                            uploadedFightImpression.isLiked = false
                        }

                        // いいねの件数
                        if let likes = likeUsers {
                            uploadedFightImpression.likeCount = likes.count
                        }

                        // 配列に加える
                        self.uploadedImpression.append(uploadedFightImpression)
                    }
                }

                // 投稿のデータが揃ったらTableViewをリロード
                self.impressionTableView.reloadData()
            }
        })

    }


    func setRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(reloadTimeline(refreshControl:)), for: .valueChanged)
        impressionTableView.addSubview(refreshControl)
    }

    @objc func reloadTimeline(refreshControl: UIRefreshControl) {
        refreshControl.beginRefreshing()
        // 更新が早すぎるので2秒遅延させる
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            refreshControl.endRefreshing()
        }
    }
}
