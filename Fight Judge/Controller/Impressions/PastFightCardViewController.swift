//
//  PastFightCardViewController.swift
//  Fight Judge
//
//  Created by 森川正崇 on 2019/11/08.
//  Copyright © 2019 morikawamasataka. All rights reserved.
//

import UIKit
import NCMB
import SafariServices
import SVProgressHUD

class PastFightCardViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,PastFightCardTableViewCellDelegate {
    
    var fightcard: String?
    var fightdate: String?
    var redfighter: String?
    var bluefighter: String?
    var url: String?
    var TotalVotes = 0
    //試合情報を入れる変数
    //選手の名前を入れる配列
    var leftFighters = ["井上尚弥","堀口恭司","那須川天心"]
    
    var rightFighters = ["ノニト・ドネア","朝倉海","志郎"]
    
    var fightCard = ["井上尚弥 vs ノニト・ドネア","堀口恭司 vs 朝倉海","那須川天心 vs 志郎"]
    
    //試合名を入れる配列
    
    //選手の年齢を入れる配列
    var leftAges = ["26","29","21"]
    
    var rightAges = ["36","26","26"]
    
    //選手の勝敗を入れる配列
    var leftResults = ["19(16K)-0-0","28(14K/3S)-3(1K/1S)-0","35(27K)-0-0"]
    
    var rightResults = ["40(26K)-6(1K)-0","14(9K/2S)-1(1K)-0","18(8K)-2-4"]
    
    //選手の決定率を入れる配列
    var leftFinishRate = ["84%","55%","77%"]
    
    var rightFinishRate = ["57%","73%","33%"]
    //選手の画像の配列
    var leftImages = [UIImage(named: "井上尚弥.jpg"),
                      UIImage(named: "堀口恭司.jpg"),
                      UIImage(named: "天心.jpg")
    ]
    var rightImages = [UIImage(named: "ノニトドネア.jpg"),
                       UIImage(named: "朝倉海.jpg"),
                       UIImage(named: "志郎.jpg")
    ]
    
    //日にちの配列
    var dates = ["2019/11/7","2019/8/18","2019/9/16"]
    var newsURL: [String] = ["https://www.google.com/search?q=%E4%BA%95%E4%B8%8A%E5%B0%9A%E5%BC%A5+%E3%83%8E%E3%83%8B%E3%83%88%E3%83%89%E3%83%8D%E3%82%A2&rlz=1C5CHFA_enJP798JP798&oq=%E4%BA%95%E4%B8%8A%E5%B0%9A%E5%BC%A5%E3%80%80%E3%81%AE%E3%81%AB&aqs=chrome.1.69i57j0l7.6892j0j7&sourceid=chrome&ie=UTF-8","https://www.google.com/search?rlz=1C5CHFA_enJP798JP798&ei=nNDQXb6sDKGJmAWv8LLAAw&q=%E5%A0%80%E5%8F%A3%E6%81%AD%E5%8F%B8+%E6%9C%9D%E5%80%89%E6%B5%B7&oq=%E5%A0%80%E5%8F%A3%E6%81%AD%E5%8F%B8+%E6%9C%9D%E5%80%89%E6%B5%B7&gs_l=psy-ab.3..0l10.15034.22247..22615...0.0..0.349.3415.27j6j0j1......0....1..gws-wiz.......0i131i67j0i67j0i7i30j0i7i4i30j0i8i7i4i30j33i160j0i4j0i4i30j0i70i251j0i10i3j0i4i37.dOyzZEeT0dY&ved=0ahUKEwi-6o2ZuPDlAhWhBKYKHS-4DDgQ4dUDCAs&uact=5","https://www.google.com/search?q=%E9%82%A3%E9%A0%88%E5%B7%9D%E5%A4%A9%E5%BF%83+%E5%BF%97%E9%83%8E&rlz=1C5CHFA_enJP798JP798&oq=%E9%82%A3%E9%A0%88%E5%B7%9D%E5%A4%A9%E5%BF%83%E3%80%80%E5%BF%97%E9%83%8E&aqs=chrome..69i57j0l6j69i61.5456j1j4&sourceid=chrome&ie=UTF-8"]
    var videoURL: [String] = ["https://www.youtube.com/results?search_query=%E4%BA%95%E4%B8%8A%E5%B0%9A%E5%BC%A5%E3%80%80%E3%83%89%E3%83%8D%E3%82%A2","https://gyao.yahoo.co.jp/player/11087/v00036/v0000000000000000695/","https://www.youtube.com/watch?v=gIoU4Hng4po"]
    
    @IBOutlet var serchBar: UISearchBar!
    @IBOutlet var pastFightCardTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //データ・ソースメソッドをこのファイル内で処理
        pastFightCardTableView.dataSource = self
        pastFightCardTableView.delegate = self
        
        //カスタムセルの登録
        let nib = UINib(nibName: "PastFightCardTableViewCell", bundle: Bundle.main)
        pastFightCardTableView.register(nib, forCellReuseIdentifier: "PastFightCardTableViewCell")
        
        
        //TableViewの不要な線を消す
        pastFightCardTableView.tableFooterView = UIView()
        //セルの高さを動的に決める
        pastFightCardTableView.rowHeight = UITableView.automaticDimension
        // 引っ張って更新
        setRefreshControl()
        
        
        
        
    }
    //セルの横幅を可変にする
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        let screenRect = UIScreen.main.bounds
        pastFightCardTableView.frame = CGRect(x: 0, y: 0, width: screenRect.width, height: screenRect.height)
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toWatchVoteResult" {
            let watchVoteResultViewController = segue.destination as! ResultOfVotesViewController
            watchVoteResultViewController.FightCard = fightcard!
            watchVoteResultViewController.FightDate = fightdate!
            watchVoteResultViewController.RedFighter = redfighter!
            watchVoteResultViewController.BlueFighter = bluefighter!
            watchVoteResultViewController.TotalVote = TotalVotes
        } else if segue.identifier == "toWatchImpression" {
            let watchImpressionViewController = segue.destination as! WatchImpressionViewController
            watchImpressionViewController.fightCard = fightcard!
            watchImpressionViewController.fightDate = fightdate!
        } else if segue.identifier == "toWriteImpression" {
            let writeImpressionViewController = segue.destination as! WriteImpressionViewController
            writeImpressionViewController.fightCard = fightcard!
            writeImpressionViewController.fightDate = fightdate!
            
        }
    }
    
    //データの個数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return leftFighters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //idを付けたcellの取得
        let cell = pastFightCardTableView.dequeueReusableCell(withIdentifier: "PastFightCardTableViewCell") as! PastFightCardTableViewCell
        
        cell.delegate = self
        cell.tag = indexPath.row
        
        
        cell.leftFighterImageView.image = leftImages[indexPath.row]
        cell.rightFighterImageView.image = rightImages[indexPath.row]
        cell.leftFighterLabel.text = leftFighters[indexPath.row]
        cell.rightFighterLabel.text = rightFighters[indexPath.row]
        cell.leftFighterAgeLabel.text = leftAges[indexPath.row]
        cell.rightFighterAgeLabel.text = rightAges[indexPath.row]
        cell.leftFighterResultsLabel.text = leftResults[indexPath.row]
        cell.rightFighterResultsLabel.text = rightResults[indexPath.row]
        cell.leftFighterFinishRateLabel.text = leftFinishRate[indexPath.row]
        cell.rightFighterFinishRateLabel.text = rightFinishRate[indexPath.row]
        cell.dateLabel.text = dates[indexPath.row]
        
        return cell
    }
    
    
    
    
    
    
    func watchVideoButtonTaped(tableViewCell: UITableViewCell, button: UIButton) {
        let video = videoURL[tableViewCell.tag]
        showSafariVC(for: video)
    }
    
    func watchNewsButtonTaped(tableViewCell: UITableViewCell, button: UIButton) {
        let news = newsURL[tableViewCell.tag]
        showSafariVC(for: news)
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
    
    func watchVote(tableViewCell: UITableViewCell, button: UIButton) {
        fightcard = fightCard[tableViewCell.tag]
        fightdate = dates[tableViewCell.tag]
        redfighter = leftFighters[tableViewCell.tag]
        bluefighter = rightFighters[tableViewCell.tag]
        // 遷移させる(このとき、prepareForSegue関数で値を渡す)
        self.performSegue(withIdentifier: "toWatchVoteResult", sender: nil)
    }
    
    func watchImpression(tableViewCell: UITableViewCell, button: UIButton) {
        fightcard = fightCard[tableViewCell.tag]
        fightdate = dates[tableViewCell.tag]
        // 遷移させる(このとき、prepareForSegue関数で値を渡す)
        self.performSegue(withIdentifier: "toWatchImpression", sender: nil)
    }
    
    func writeImpression(tableViewCell: UITableViewCell, button: UIButton) {
        fightcard = fightCard[tableViewCell.tag]
        fightdate = dates[tableViewCell.tag]
        //遷移させる(このとき、prepareForSegue関数で値を渡す)
        self.performSegue(withIdentifier: "toWriteImpression", sender: nil)
    }
    
    func setRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(reloadTimeline(refreshControl:)), for: .valueChanged)
        pastFightCardTableView.addSubview(refreshControl)
    }
    
    @objc func reloadTimeline(refreshControl: UIRefreshControl) {
        refreshControl.beginRefreshing()
        //何かアクション(試合などの更新を行うなど)をする今は未定
        
        
        // 更新が早すぎるので2秒遅延させる
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            refreshControl.endRefreshing()
        }
    }
    
}
