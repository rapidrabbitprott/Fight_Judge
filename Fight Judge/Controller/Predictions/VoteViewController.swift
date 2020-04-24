//
//  VoteViewController.swift
//  Fight Judge
//
//  Created by 森川正崇 on 2019/09/27.
//  Copyright © 2019 morikawamasataka. All rights reserved.
//

import UIKit
import NCMB
import SVProgressHUD

class VoteViewController: UIViewController {
    @IBOutlet var redFighterName1: UILabel!
    @IBOutlet var blueFighterName1: UILabel!
    @IBOutlet var redFighterName2: UILabel!
    @IBOutlet var blueFighterName2: UILabel!
    
    //選手名の受取
    var redFighter = ""
    var blueFighter = ""
    //試合名の受け取り
    var fightCard = ""
    var fightDate = ""
    //ユーザー名生成
    let userName = NCMBUser.current()?.object(forKey: "userName") as? String
    //クエリの生成
    let query = NCMBQuery(className: "VotePrediction")
    
    var redsKO = 0
    var redsDecision = 0
    var draw = 0
    var bluesKO = 0
    var blueDecision = 0
    var totalVotes = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        redFighterName1.text = redFighter + "のKO勝ち"
        redFighterName2.text = redFighter + "の判定勝ち"
        blueFighterName1.text = blueFighter + "のKO勝ち"
        blueFighterName2.text = blueFighter + "の判定勝ち"
    }
    
    @IBAction func voteRedKO() {
        vote(voteOfFights: "Red`s KO")
        SVProgressHUD.show()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            //1秒後に実行したい処理をここに書く
            self.countVoteResults()
            self.countTotalVotes()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            //2秒後に実行したい処理をここに書く
            SVProgressHUD.dismiss()
            self.nextView()
        }
    }
    
    @IBAction func voteRedDecision() {
        vote(voteOfFights: "Red`s Decision")
        SVProgressHUD.show()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            //1秒後に実行したい処理をここに書く
            self.countVoteResults()
            self.countTotalVotes()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            //2秒後に実行したい処理をここに書く
            SVProgressHUD.dismiss()
            self.nextView()
        }
    }
    
    @IBAction func voteDraw() {
        vote(voteOfFights: "Draw")
        SVProgressHUD.show()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            //1秒後に実行したい処理をここに書く
            self.countVoteResults()
            self.countTotalVotes()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            //2秒後に実行したい処理をここに書く
            SVProgressHUD.dismiss()
            self.nextView()
        }
    }
    @IBAction func voteBlueKO() {
        vote(voteOfFights: "Blue`s KO")
        SVProgressHUD.show()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            //1秒後に実行したい処理をここに書く
            self.countVoteResults()
            self.countTotalVotes()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            //2秒後に実行したい処理をここに書く
            SVProgressHUD.dismiss()
            self.nextView()
        }
    }
    
    @IBAction func voteBlueDecision() {
        vote(voteOfFights: "Blue`s Decision")
        SVProgressHUD.show()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            //1秒後に実行したい処理をここに書く
            self.countVoteResults()
            self.countTotalVotes()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            //2秒後に実行したい処理をここに書く
            SVProgressHUD.dismiss()
            self.nextView()
        }
    }
    
    func vote(voteOfFights: String) {
        //投票記録が残っていれば更新/残っていなかったら保存
        //ユーザー名・試合名で絞り込み
        query?.whereKey("userName", equalTo: userName)
        query?.whereKey("fightCard", equalTo: fightCard)
        
        //データがあれば更新/無ければ保存
        query?.findObjectsInBackground({ (result, error) in
            if error != nil {
                SVProgressHUD.showError(withStatus: error!.localizedDescription)
            } else {
                if  result as! [NCMBObject] != [] {
                    let votes = result as! [NCMBObject]
                    let voteAs = votes.first
                    voteAs?.setObject(voteOfFights, forKey: "voteAs")
                    voteAs?.saveInBackground({ (error) in
                        if error != nil {
                            SVProgressHUD.showError(withStatus: error!.localizedDescription)
                        } else {
                            print("update")
                        }
                    })
                } else {
                    //新しいデータを保存
                    //class生成
                    let object = NCMBObject(className: "VotePrediction")
                    //ユーザー名,試合名,予想投票を識別子として追加
                    let userName = NCMBUser.current()?.object(forKey: "userName") as? String
                    object?.setObject(userName, forKey: "userName")
                    object?.setObject(self.fightCard, forKey: "fightCard")
                    object?.setObject(voteOfFights, forKey: "voteAs")
                    //保存
                    object?.saveInBackground({ (error) in
                        if error != nil {
                            SVProgressHUD.showError(withStatus: error!.localizedDescription)
                        } else {
                            print("saved")
                        }
                    })
                }
                
            }
            
        })
    }
    
    func countTotalVotes() {
        let query = NCMBQuery(className: "VotePrediction")
        query?.whereKey("fightCard", equalTo: self.fightCard)
        query?.countObjectsInBackground({ (count, error) in
            if error != nil {
                SVProgressHUD.showError(withStatus: error!.localizedDescription)
            } else {
                self.totalVotes = Int(count)
            }
        })
        
    }
    
    func countVoteResults() {
        let query = NCMBQuery(className: "VotePrediction")
        
        query?.whereKey("fightCard", equalTo: self.fightCard)
        query?.whereKey("voteAs", equalTo: "Red`s KO")
        query?.countObjectsInBackground({ (count, error) in
            if error != nil {
                SVProgressHUD.showError(withStatus: error!.localizedDescription)
            } else {
                self.redsKO = Int(count)
            }
        })
        
        query?.whereKey("fightCard", equalTo: self.fightCard)
        query?.whereKey("voteAs", equalTo: "Red`s Decision")
        query?.countObjectsInBackground({ (count, error) in
            if error != nil {
                SVProgressHUD.showError(withStatus: error!.localizedDescription)
            } else {
                self.redsDecision = Int(count)
                
            }
        })
        
        query?.whereKey("fightCard", equalTo: self.fightCard)
        query?.whereKey("voteAs", equalTo: "Draw")
        query?.countObjectsInBackground({ (count, error) in
            if error != nil {
                SVProgressHUD.showError(withStatus: error!.localizedDescription)
            } else {
                
                self.draw = Int(count)
                
            }
        })
        
        query?.whereKey("fightCard", equalTo: self.fightCard)
        query?.whereKey("voteAs", equalTo: "Blue`s KO")
        query?.countObjectsInBackground({ (count, error) in
            if error != nil {
                SVProgressHUD.showError(withStatus: error!.localizedDescription)
            } else {
                self.bluesKO = Int(count)
            }
        })
        
        query?.whereKey("fightCard", equalTo: self.fightCard)
        query?.whereKey("voteAs", equalTo: "Blue`s Decision")
        query?.countObjectsInBackground({ (count, error) in
            if error != nil {
                SVProgressHUD.showError(withStatus: error!.localizedDescription)
            } else {
                self.blueDecision = Int(count)
            }
        })
    }
    
    func nextView() {
        self.performSegue(withIdentifier: "toWatchVote", sender: nil)
        
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toWatchVote" {
            let watchVoteViewController = segue.destination as! WatchVoteViewController
            watchVoteViewController.passedRedFighter = self.redFighter
            watchVoteViewController.passedBlueFighter = self.blueFighter
            watchVoteViewController.passedFightCard = self.fightCard
            watchVoteViewController.passedFightDate = self.fightDate
            
            watchVoteViewController.passedRedsKO = self.redsKO
            watchVoteViewController.passedRedsDecision = self.redsDecision
            watchVoteViewController.passedDraw = self.draw
            watchVoteViewController.passedBluesKO = self.bluesKO
            watchVoteViewController.passedBlueDecision = self.blueDecision
            watchVoteViewController.passedTotalVote = self.totalVotes
        }
    }
    
}

