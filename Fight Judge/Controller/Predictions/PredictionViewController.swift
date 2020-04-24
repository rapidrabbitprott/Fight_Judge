//
//  PredictionViewController.swift
//  Fight Judge
//
//  Created by 森川正崇 on 2019/09/19.
//  Copyright © 2019 morikawamasataka. All rights reserved.
//

import UIKit
import SafariServices

class PredictionViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,FightCardTableViewCellDelegate{
    
    var fightcard: String?
    var fightdate: String?
    var redfighter: String?
    var bluefighter: String?
    var url: String?
    var ppvurl : String?
    var ticketurl: String?
    //選手の名前を入れる配列
    var leftFighters = ["那須川天心","堀口恭司","村田諒太","朝倉未来","武尊"]
    
    var rightFighters = ["武尊","朝倉海","スティーブン・バトラー","ジョン・マカパ","村越優汰"]
    
    var fightCard = ["那須川天心 vs 武尊","堀口恭司 vs 朝倉海","村田諒太 vs スティーブン・バトラー","朝倉未来 vs ジョン・マカパ","武尊 vs 村越優汰"]
    
    //試合名を入れる配列
    
    //選手の年齢を入れる配列
    var leftAges = ["21","29","33","27","28"]
    
    var rightAges = ["28","26","24","32","25"]
    
    //選手の勝敗を入れる配列
    var leftResults = ["35(27K)-0-0","28(14K/3S)-3(1K/1S)-0","17(15K)-2-0","11(6K/1S)-1-0","37(22K)-1(1K)-0"]
    
    var rightResults = ["37(22K)-1(1K)-0","14(9K/2S)-1(1K)-0","28(24K)-1(1K)-1","23(5K/10S)-4(1K)-0","28(11K)-7(2K)-0"]
    
    //選手の決定率を入れる配列
    var leftFinishRate = ["77%","55%","79%","58%","58%"]
    
    var rightFinishRate = ["58%","73%","80%","56%","31%"]
    //選手の画像の配列
    var leftImages = [UIImage(named: "天心.jpg"),
                      UIImage(named:"堀口恭司.jpg"),
                      UIImage(named: "村田諒太.jpg"),
                      UIImage(named: "朝倉未来.jpg"),
                      UIImage(named: "武尊.jpg")
    ]
    var rightImages = [UIImage(named: "武尊.jpg"),
                       UIImage(named: "朝倉海.jpg"),
                       UIImage(named: "スティーブンバトラー.jpg"),
                       UIImage(named: "ジョン・マカパ.jpeg"),
                       UIImage(named: "村越ゆうた.jpeg")
    ]
    
    //日にちの配列
    var dates = ["COMMING SOON","COMMING SOON","2019/12/31","2019/12/31","2019/11/24"]
    var newsURL: [String] = ["https://www.google.com/search?rlz=1C5CHFA_enJP798JP798&ei=rsbQXY8dtd2YBfr7v5AC&q=%E9%82%A3%E9%A0%88%E5%B7%9D%E5%A4%A9%E5%BF%83+vs+%E6%AD%A6%E5%B0%8A&oq=%E9%82%A3%E9%A0%88%E5%B7%9D%E5%A4%A9%E5%BF%83+vs+%E6%AD%A6%E5%B0%8A&gs_l=psy-ab.3..0.4175.4778..5092...0.0..0.240.420.2j0j1......0....1..gws-wiz.......0i7i30.2PFcleYRp54&ved=0ahUKEwiPrPLcrvDlAhW1LqYKHfr9DyIQ4dUDCAs&uact=5","https://www.google.com/search?rlz=1C5CHFA_enJP798JP798&ei=s8bQXZCyObSWr7wP-OapmAQ&q=%E5%A0%80%E5%8F%A3%E6%81%AD%E5%8F%B8+vs+%E6%9C%9D%E5%80%89%E6%B5%B7&oq=%E5%A0%80%E5%8F%A3%E6%81%AD%E5%8F%B8+vs+%E6%9C%9D%E5%80%89%E6%B5%B7&gs_l=psy-ab.3..0l8.80946.88750..89317...1.0..0.213.2987.28j3j1......0....1..gws-wiz.......0i8i7i30j0i7i30j0i8i30j0i8i10i30j33i21j0i4.bxBXIwdslNQ&ved=0ahUKEwjQ19zfrvDlAhU0y4sBHXhzCkMQ4dUDCAs&uact=5","https://www.google.com/search?rlz=1C5CHFA_enJP798JP798&ei=88fQXf7oEMb6-QaPhbzIBQ&q=%E6%9D%91%E7%94%B0%E8%AB%92%E5%A4%AA%E3%80%80%E3%82%B9%E3%83%86%E3%82%A3%E3%83%BC%E3%83%96%E3%83%B3%E3%83%90%E3%83%88%E3%83%A9%E3%83%BC&oq=%E6%9D%91%E7%94%B0%E8%AB%92%E5%A4%AA%E3%80%80%E3%82%B9%E3%83%86%E3%82%A3%E3%83%BC%E3%83%96%E3%83%B3%E3%83%90%E3%83%88%E3%83%A9%E3%83%BC&gs_l=psy-ab.3...8810.13883..14339...4.2..0.110.1825.18j3......0....1..gws-wiz.......0i71j0i4j0j0i131j33i160.C8Rk89nlbTM&ved=0ahUKEwi-rv_3r_DlAhVGfd4KHY8CD1kQ4dUDCAs&uact=5","https://www.google.com/search?rlz=1C5CHFA_enJP798JP798&ei=08jQXaxt55GvvA_Qip6YCg&q=%E6%9C%9D%E5%80%89%E6%9C%AA%E6%9D%A5+%E3%82%B8%E3%83%A7%E3%83%B3%E3%83%BB%E3%83%9E%E3%82%AB%E3%83%91&oq=%E6%9C%9D%E5%80%89%E6%9C%AA%E6%9D%A5+%E3%82%B8%E3%83%A7%E3%83%B3%E3%83%BB%E3%83%9E%E3%82%AB%E3%83%91&gs_l=psy-ab.3...3216.10563..11075...2.0..0.100.1524.16j2......0....1..gws-wiz.QveWx7twQ14&ved=0ahUKEwjsotfisPDlAhXnyIsBHVCFB6MQ4dUDCAs&uact=5","https://www.google.com/search?q=%E6%AD%A6%E5%B0%8A+%E6%9D%91%E8%B6%8A&rlz=1C5CHFA_enJP798JP798&oq=%E6%AD%A6%E5%B0%8A+mu&aqs=chrome.1.69i57j0l7.8622j0j4&sourceid=chrome&ie=UTF-8"]
    var ppvURL: [String] = ["https://www.google.com/search?rlz=1C5CHFA_enJP798JP798&ei=rsbQXY8dtd2YBfr7v5AC&q=%E9%82%A3%E9%A0%88%E5%B7%9D%E5%A4%A9%E5%BF%83+vs+%E6%AD%A6%E5%B0%8A&oq=%E9%82%A3%E9%A0%88%E5%B7%9D%E5%A4%A9%E5%BF%83+vs+%E6%AD%A6%E5%B0%8A&gs_l=psy-ab.3..0.4175.4778..5092...0.0..0.240.420.2j0j1......0....1..gws-wiz.......0i7i30.2PFcleYRp54&ved=0ahUKEwiPrPLcrvDlAhW1LqYKHfr9DyIQ4dUDCAs&uact=5","https://www.google.com/search?rlz=1C5CHFA_enJP798JP798&ei=s8bQXZCyObSWr7wP-OapmAQ&q=%E5%A0%80%E5%8F%A3%E6%81%AD%E5%8F%B8+vs+%E6%9C%9D%E5%80%89%E6%B5%B7&oq=%E5%A0%80%E5%8F%A3%E6%81%AD%E5%8F%B8+vs+%E6%9C%9D%E5%80%89%E6%B5%B7&gs_l=psy-ab.3..0l8.80946.88750..89317...1.0..0.213.2987.28j3j1......0....1..gws-wiz.......0i8i7i30j0i7i30j0i8i30j0i8i10i30j33i21j0i4.bxBXIwdslNQ&ved=0ahUKEwjQ19zfrvDlAhU0y4sBHXhzCkMQ4dUDCAs&uact=5","https://www3.nhk.or.jp/news/html/20191016/k10012134501000.html","https://headlines.yahoo.co.jp/hl?a=20191116-00000007-gbr-fight","https://abema.tv/channels/fighting-sports/slots/DkHknJ18xtyy1H"]
    var ticketURL: [String] = ["https://www.google.com/search?rlz=1C5CHFA_enJP798JP798&ei=rsbQXY8dtd2YBfr7v5AC&q=%E9%82%A3%E9%A0%88%E5%B7%9D%E5%A4%A9%E5%BF%83+vs+%E6%AD%A6%E5%B0%8A&oq=%E9%82%A3%E9%A0%88%E5%B7%9D%E5%A4%A9%E5%BF%83+vs+%E6%AD%A6%E5%B0%8A&gs_l=psy-ab.3..0.4175.4778..5092...0.0..0.240.420.2j0j1......0....1..gws-wiz.......0i7i30.2PFcleYRp54&ved=0ahUKEwiPrPLcrvDlAhW1LqYKHfr9DyIQ4dUDCAs&uact=5","https://www.google.com/search?rlz=1C5CHFA_enJP798JP798&ei=s8bQXZCyObSWr7wP-OapmAQ&q=%E5%A0%80%E5%8F%A3%E6%81%AD%E5%8F%B8+vs+%E6%9C%9D%E5%80%89%E6%B5%B7&oq=%E5%A0%80%E5%8F%A3%E6%81%AD%E5%8F%B8+vs+%E6%9C%9D%E5%80%89%E6%B5%B7&gs_l=psy-ab.3..0l8.80946.88750..89317...1.0..0.213.2987.28j3j1......0....1..gws-wiz.......0i8i7i30j0i7i30j0i8i30j0i8i10i30j33i21j0i4.bxBXIwdslNQ&ved=0ahUKEwjQ19zfrvDlAhU0y4sBHXhzCkMQ4dUDCAs&uact=5","https://l-tike.com/search/?lcd=35132","https://eplus.jp/sf/detail/1784450013-P0030029?P4=015&P6=001","http://k-1.shop/ticket/products/detail.php?product_id=630"]
    
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var fightCardTableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //データ・ソースメソッドをこのファイル内で処理
        fightCardTableView.dataSource = self
        //デリゲートメソッドをこのファイル内で処理する
        fightCardTableView.delegate = self
        
        //カスタムセルの登録
        let nib = UINib(nibName: "FightCardTableViewCell", bundle: Bundle.main)
        fightCardTableView.register(nib, forCellReuseIdentifier: "FightCardTableViewCell")
        
        //TableViewの不要な線を消す
        fightCardTableView.tableFooterView = UIView()
        //セルの高さを動的に決める
        fightCardTableView.rowHeight = UITableView.automaticDimension
        
        
        setRefreshControl()
    }
    
    //セルの横幅を可変にする
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        let screenRect = UIScreen.main.bounds
        fightCardTableView.frame = CGRect(x: 0, y: 0, width: screenRect.width, height: screenRect.height)
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toVote" {
            let voteViewController = segue.destination as! VoteViewController
            voteViewController.fightCard = fightcard!
            voteViewController.fightDate = fightdate!
            voteViewController.redFighter = redfighter!
            voteViewController.blueFighter = bluefighter!
        } else if segue.identifier == "toWatchPrediction" {
            let watchPredictionViewController = segue.destination as! WatchPredictionViewController
            watchPredictionViewController.fightCard = fightcard!
            watchPredictionViewController.fightDate = fightdate!
            watchPredictionViewController.ppvURL = ppvurl!
            watchPredictionViewController.ticketURL = ticketurl!
        } else if segue.identifier == "toWritePrediction" {
            let writePredictionViewController = segue.destination as! WritePredictionViewController
            writePredictionViewController.fightCard = fightcard!
            writePredictionViewController.fightDate = fightdate!
            
        }
    }
    
    //1.TableViewに表示するデータの個数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return leftFighters.count
    }
    //2TableViewに表示するデータの内容を宣言
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //idをつけたcellの個数
        let cell = tableView.dequeueReusableCell(withIdentifier: "FightCardTableViewCell") as! FightCardTableViewCell
        
        cell.delegate = self
        cell.tag = indexPath.row
        
        //表示内容を決める
        cell.leftFigterLabel.text = leftFighters[indexPath.row]
        cell.rightFighterLabel.text = rightFighters[indexPath.row]
        cell.leftFighterImageView.image = leftImages[indexPath.row]
        cell.rightFighterImageView.image = rightImages[indexPath.row]
        cell.leftFighterAgeLabel.text = leftAges[indexPath.row]
        cell.rightFighterAgeLabel.text = rightAges[indexPath.row]
        cell.leftFighterResultsLabel.text = leftResults[indexPath.row]
        cell.rightFighterResultsLabel.text = rightResults[indexPath.row]
        cell.leftFighterFinishRateLabel.text = leftFinishRate[indexPath.row]
        cell.rightFighterFinishRateLabel.text = rightFinishRate[indexPath.row]
        cell.dateLabel.text = dates[indexPath.row]
        //cellを返す
        return cell
    }
    
    func vote(tableViewCell: UITableViewCell, button: UIButton) {
        fightcard = fightCard[tableViewCell.tag]
        fightdate = dates[tableViewCell.tag]
        redfighter = leftFighters[tableViewCell.tag]
        bluefighter = rightFighters[tableViewCell.tag]
        //遷移させる(このとき、prepareForSegue関数で値を渡す)
        self.performSegue(withIdentifier: "toVote", sender: nil)
    }
    
    func watchPrediction(tableViewCell: UITableViewCell, button: UIButton) {
        fightcard = fightCard[tableViewCell.tag]
        fightdate = dates[tableViewCell.tag]
        ticketurl = ticketURL[tableViewCell.tag]
        ppvurl = ppvURL[tableViewCell.tag]
        //遷移させる(このとき、prepareForSegue関数で値を渡す)
        self.performSegue(withIdentifier: "toWatchPrediction", sender: nil)
    }
    
    func writePrediction(tableViewCell: UITableViewCell, button: UIButton) {
        
        fightcard = fightCard[tableViewCell.tag]
        fightdate = dates[tableViewCell.tag] //遷移させる(このとき、prepareForSegue関数で値を渡す)
        self.performSegue(withIdentifier: "toWritePrediction", sender: nil)
    }
    
    func notice(tableViewCell: UITableViewCell, button: UIButton) {
        let alertController = UIAlertController(title: "登録完了", message: "試合前日に通知します。", preferredStyle: .alert)
        //OKを押したら別の画面に遷移
        let action = UIAlertAction(title: "OK", style: .default) { (action) in
        }
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func buyPPV(tableViewCell: UITableViewCell, button: UIButton) {
        let ppv = ppvURL[tableViewCell.tag]
        showSafariVC(for: ppv)
    }
    
    func buyTicket(tableViewCell: UITableViewCell, button: UIButton) {
        let ticket = ticketURL[tableViewCell.tag]
        showSafariVC(for: ticket)
    }
    
    func watchNews(tableViewCell: UITableViewCell, button: UIButton) {
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
    
    func setRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(reloadTimeline(refreshControl:)), for: .valueChanged)
        fightCardTableView.addSubview(refreshControl)
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
