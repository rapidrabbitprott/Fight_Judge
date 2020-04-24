//
//  VoteViewController.swift
//  Fight Judge
//
//  Created by 森川正崇 on 2019/09/27.
//  Copyright © 2019 morikawamasataka. All rights reserved.
//

import UIKit
import Charts
import NCMB
import SVProgressHUD

class ResultOfVotesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    //選手名の受取
    var RedFighter = ""
    var BlueFighter = ""
    //試合名の受け取り
    var FightCard = ""
    var FightDate = ""
    var TotalVote = 0
    var RedsKO = 0
    var RedsDecision = 0
    var Draw = 0
    var BluesKO = 0
    var BlueDecision = 0
    
    var commentToVotes = [CommentToVotes]()
    
    
    @IBOutlet var pieChartsView: PieChartView!
    @IBOutlet var commentToVotesTableView: UITableView!
    override func viewDidLoad() {

        super.viewDidLoad()
        //データ・ソースメソッドをこのファイル内で処理する
        commentToVotesTableView.dataSource = self
        //TableViewの不要な線を消す
        commentToVotesTableView.tableFooterView = UIView()
        //cellの高さを指定
        commentToVotesTableView.rowHeight = 85
        //引張って更新
        setRefreshControl()
        
        loadComments()
        
        let redsKO = RedFighter + "のKO勝ち"
        let redsDecision = RedFighter + "の判定勝ち"
        let bluesKO = BlueFighter + "のKO勝ち"
        let bluesDecision = BlueFighter + "の判定勝ち"


        let query = NCMBQuery(className: "VotePrediction")


        
        
        query?.whereKey("fightCard", equalTo: FightCard)
        query?.countObjectsInBackground({ (count, error) in
            if error != nil {
                SVProgressHUD.showError(withStatus: error!.localizedDescription)
            } else {
                self.TotalVote = Int(count)
            }
        })
        
        
        

        query?.whereKey("fightCard", equalTo: FightCard)
        query?.whereKey("voteAs", equalTo: "Red`s KO")
        query?.countObjectsInBackground({ (count, error) in
            if error != nil {
                SVProgressHUD.showError(withStatus: error!.localizedDescription)
            } else {
                self.RedsKO = Int(count)
            }
        })


        query?.whereKey("fightCard", equalTo: FightCard)
        query?.whereKey("voteAs", equalTo: "Red`s Decision")
        query?.countObjectsInBackground({ (count, error) in
            if error != nil {
                SVProgressHUD.showError(withStatus: error!.localizedDescription)
            } else {
                self.RedsDecision = Int(count)
                
            }
        })


        query?.whereKey("fightCard", equalTo: FightCard)
        query?.whereKey("voteAs", equalTo: "Draw")
        query?.countObjectsInBackground({ (count, error) in
            if error != nil {
                SVProgressHUD.showError(withStatus: error!.localizedDescription)
            } else {

                self.Draw = Int(count)

            }
        })


        query?.whereKey("fightCard", equalTo: FightCard)
        query?.whereKey("voteAs", equalTo: "Blue`s KO")
        query?.countObjectsInBackground({ (count, error) in
            if error != nil {
                SVProgressHUD.showError(withStatus: error!.localizedDescription)
            } else {
                self.BluesKO = Int(count)
            }
        })


        query?.whereKey("fightCard", equalTo: FightCard)
        query?.whereKey("voteAs", equalTo: "Blue`s Decision")
        query?.countObjectsInBackground({ (count, error) in
            if error != nil {
                SVProgressHUD.showError(withStatus: error!.localizedDescription)
            } else {
                self.BlueDecision = Int(count)
            }
        })

        SVProgressHUD.show()

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.0) {
            SVProgressHUD.dismiss()
            let TotalVotes = "投票数:" + String(self.TotalVote)  + "票"
            // グラフに表示するデータのタイトルと値
            var dataEntries = [PieChartDataEntry]()
            var colores : [UIColor] = []

            if self.RedsKO != 0 {
                dataEntries.append(PieChartDataEntry(value: Double(self.RedsKO), label: redsKO))
                colores.append(UIColor.init(red: 255/255, green: 0/255, blue: 0/255, alpha: 1))
            }
            if self.RedsDecision != 0 {
                dataEntries.append(PieChartDataEntry(value: Double(self.RedsDecision), label: redsDecision))
                colores.append(UIColor.init(red: 255/255, green: 69/255, blue: 0/255, alpha: 1))
            }
            if self.Draw != 0 {
                dataEntries.append(PieChartDataEntry(value: Double(self.Draw), label: "Draw"))
                colores.append(UIColor.black)
            }
            if self.BluesKO != 0 {
                dataEntries.append(PieChartDataEntry(value: Double(self.BluesKO), label: bluesKO))
                colores.append(UIColor.blue)
            }
            if self.BlueDecision != 0 {
                dataEntries.append(PieChartDataEntry(value: Double(self.BlueDecision), label: bluesDecision))
                colores.append(UIColor.init(red: 135/255, green: 206/255, blue: 250/255, alpha: 1))
            }


            let dataSet = PieChartDataSet(entries: dataEntries, label: TotalVotes)

            // グラフの色
            dataSet.colors = colores
            // グラフのデータの値の色
            dataSet.valueTextColor = UIColor.white
            // グラフのデータのタイトルの色
            dataSet.entryLabelColor = UIColor.white

            self.pieChartsView.data = PieChartData(dataSet: dataSet)

            // データを％表示にする
            let formatter = NumberFormatter()
            formatter.numberStyle = .percent
            formatter.maximumFractionDigits = 2
            formatter.multiplier = 1.0
            formatter.maximumFractionDigits = 1

            self.pieChartsView.data?.setValueFormatter(DefaultValueFormatter(formatter: formatter))
            self.pieChartsView.usePercentValuesEnabled = true
            self.pieChartsView.drawHoleEnabled = false
            self.pieChartsView.drawEntryLabelsEnabled = false


            self.view.addSubview(self.pieChartsView)
        }
        
       
    }
    override func viewWillAppear(_ animated: Bool) {
        loadComments()
        commentToVotesTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentToVotes.count
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
        
        let user = commentToVotes[indexPath.row].user
        let userImagePath = "https://mbaas.api.nifcloud.com/2013-09-01/applications/NB9tDVZPBMUmsRJC/publicFiles/" + user.objectId
        userImageView.kf.setImage(with: URL(string: userImagePath))
        userNameLabel.text = user.displayName
        commentLabel.text = commentToVotes[indexPath.row].text
        
        return cell
    }
    
    func loadComments() {
           let query = NCMBQuery(className: "CommentToVotes")
           query?.whereKey("fightCard", equalTo: FightCard)
           query?.whereKey("fightDate", equalTo: FightDate)
           // 降順
           query?.order(byDescending: "createDate")
           query?.includeKey("user")
           query?.findObjectsInBackground({ (result, error) in
               if error != nil {
                   SVProgressHUD.showError(withStatus: error!.localizedDescription)
               } else {
                   self.commentToVotes = [CommentToVotes]()
                   for commentObject in result as! [NCMBObject] {
                       // コメントをしたユーザーの情報を取得
                       let user = commentObject.object(forKey: "user") as! NCMBUser
                       let userModel = User(objectId: user.objectId, userName: user.userName)
                       userModel.displayName = user.object(forKey: "displayName") as? String
                       
                       // コメントの文字を取得
                       let text = commentObject.object(forKey: "text") as! String
                       
                       // Commentクラスに格納
                    let comment = CommentToVotes(user: userModel, text: text, createDate: commentObject.createDate)
                       self.commentToVotes.append(comment)
                       // テーブルをリロード
                       self.commentToVotesTableView.reloadData()
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
            let object = NCMBObject(className: "CommentToVotes")
            object?.setObject(self.FightCard, forKey: "fightCard")
            object?.setObject(self.FightDate, forKey: "fightDate")
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
        commentToVotesTableView.addSubview(refreshControl)
    }
    
    @objc func reloadTimeline(refreshControl: UIRefreshControl) {
        refreshControl.beginRefreshing()
        // 更新が早すぎるので2秒遅延させる
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            refreshControl.endRefreshing()
        }
    }
}

