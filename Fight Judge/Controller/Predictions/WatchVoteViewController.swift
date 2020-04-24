//
//  VoteViewController.swift
//  Fight Judge
//
//  Created by 森川正崇 on 2019/09/27.
//  Copyright © 2019 morikawamasataka. All rights reserved.
//

import UIKit
import NCMB
import Kingfisher
import SVProgressHUD
import SwiftDate
import Charts


class WatchVoteViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CommentTableViewCellDelegate {
    //選手名の受取
    var passedRedFighter = ""
    var passedBlueFighter = ""
    //試合名の受け取り
    var passedFightCard = ""
    var passedFightDate = ""
    //投票結果の受け取り
    var passedTotalVote = 0
    var passedRedsKO = 0
    var passedRedsDecision = 0
    var passedDraw = 0
    var passedBluesKO = 0
    var passedBlueDecision = 0
    
    var commentToVotes = [CommentToVotes]()
    
    @IBOutlet var watchVotesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //データ・ソースメソッドをこのファイル内で処理する
        watchVotesTableView.dataSource = self
        //TableViewの不要な線を消す
        watchVotesTableView.tableFooterView = UIView()
        //セルの高さを動的に決める
        watchVotesTableView.rowHeight = UITableView.automaticDimension
        //カスタムセルの登録
        let nib1 = UINib(nibName: "ChartsTableViewCell", bundle: Bundle.main)
        watchVotesTableView.register(nib1, forCellReuseIdentifier: "ChartsTableViewCell")
        
        let nib2 = UINib(nibName: "CommentTableViewCell", bundle: Bundle.main)
        watchVotesTableView.register(nib2, forCellReuseIdentifier: "CommentTableViewCell")
        //引張って更新
        setRefreshControl()
        
        loadComments()
        
    }
    
    //セルの横幅を可変にする
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let screenRect = UIScreen.main.bounds
        watchVotesTableView.frame = CGRect(x: 0, y: 0, width: screenRect.width, height: screenRect.height)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadComments()
        watchVotesTableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return commentToVotes.count
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let redsKO = self.passedRedFighter + "のKO勝ち"
            let redsDecision = self.passedRedFighter + "の判定勝ち"
            let bluesKO = self.passedBlueFighter + "のKO勝ち"
            let bluesDecision = self.passedBlueFighter + "の判定勝ち"
            let TotalVotes = "投票数:" + String(self.passedTotalVote)  + "票"
            let chartsViewCell = tableView.dequeueReusableCell(withIdentifier: "ChartsTableViewCell") as! ChartsTableViewCell
            print(redsKO)
            // グラフに表示するデータのタイトルと値
            var dataEntries = [PieChartDataEntry]()
            var colores : [UIColor] = []
            
            if self.passedRedsKO != 0 {
                dataEntries.append(PieChartDataEntry(value: Double(self.passedRedsKO), label: redsKO))
                colores.append(UIColor.init(red: 255/255, green: 0/255, blue: 0/255, alpha: 1))
            }
            if self.passedRedsDecision != 0 {
                dataEntries.append(PieChartDataEntry(value: Double(self.passedRedsDecision), label: redsDecision))
                colores.append(UIColor.init(red: 255/255, green: 69/255, blue: 0/255, alpha: 1))
            }
            if self.passedDraw != 0 {
                dataEntries.append(PieChartDataEntry(value: Double(self.passedDraw), label: "Draw"))
                colores.append(UIColor.black)
            }
            if self.passedBluesKO != 0 {
                dataEntries.append(PieChartDataEntry(value: Double(self.passedBluesKO), label: bluesKO))
                colores.append(UIColor.blue)
            }
            if self.passedBlueDecision != 0 {
                dataEntries.append(PieChartDataEntry(value: Double(self.passedBlueDecision), label: bluesDecision))
                colores.append(UIColor.init(red: 135/255, green: 206/255, blue: 250/255, alpha: 1))
            }
            
            let dataSet = PieChartDataSet(entries: dataEntries, label: TotalVotes)
            print(dataSet)
            // グラフの色
            dataSet.colors = colores
            // グラフのデータの値の色
            dataSet.valueTextColor = UIColor.white
            // グラフのデータのタイトルの色
            dataSet.entryLabelColor = UIColor.white
            
            chartsViewCell.pieChartsView.data = PieChartData(dataSet: dataSet)
            
            
            
            // データを％表示にする
            let formatter = NumberFormatter()
            formatter.numberStyle = .percent
            formatter.maximumFractionDigits = 2
            formatter.multiplier = 1.0
            formatter.maximumFractionDigits = 1
            chartsViewCell.pieChartsView.data?.setValueFormatter(DefaultValueFormatter(formatter: formatter))
            
            chartsViewCell.pieChartsView.usePercentValuesEnabled = true
            chartsViewCell.pieChartsView.drawEntryLabelsEnabled = false
            chartsViewCell.pieChartsView.drawHoleEnabled = false
            chartsViewCell.addSubview(chartsViewCell.pieChartsView)
            
            return chartsViewCell
        } else {
            let commentToVotesCell = tableView.dequeueReusableCell(withIdentifier: "CommentTableViewCell") as! CommentTableViewCell
            let user = commentToVotes[indexPath.row].user
            let userImagePath = "https://mbaas.api.nifcloud.com/2013-09-01/applications/NB9tDVZPBMUmsRJC/publicFiles/" + user.objectId
            commentToVotesCell.userImageView.kf.setImage(with: URL(string: userImagePath))
            commentToVotesCell.userNameLabel.text = user.displayName
            commentToVotesCell.commentLabel.text = commentToVotes[indexPath.row].text
            let date = String(commentToVotes[indexPath.row].createDate.year) + "/" + String(commentToVotes[indexPath.row].createDate.month) + "/" + String(commentToVotes[indexPath.row].createDate.day)
            commentToVotesCell.timestampLabel.text = date
            return commentToVotesCell
            
        }
    }
    
    func loadComments() {
        let query = NCMBQuery(className: "CommentToVotes")
        query?.whereKey("fightCard", equalTo: passedFightCard)
        query?.whereKey("fightDate", equalTo: passedFightDate)
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
                    self.watchVotesTableView.reloadData()
                }
                
                
            }
        })
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
    
    @IBAction func addComment() {
        let alert = UIAlertController(title: "コメント", message: "コメントを入力して下さい", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "キャンセル", style: .default) { (action) in
            alert.dismiss(animated: true, completion: nil)
        }
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            alert.dismiss(animated: true, completion: nil)
            SVProgressHUD.show()
            let object = NCMBObject(className: "CommentToVotes")
            object?.setObject(self.passedFightCard, forKey: "fightCard")
            object?.setObject(self.passedFightDate, forKey: "fightDate")
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
        watchVotesTableView.addSubview(refreshControl)
    }
    
    @objc func reloadTimeline(refreshControl: UIRefreshControl) {
        refreshControl.beginRefreshing()
        // 更新が早すぎるので2秒遅延させる
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            refreshControl.endRefreshing()
        }
    }
}
