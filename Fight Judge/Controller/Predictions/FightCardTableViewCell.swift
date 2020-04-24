//
//  FightCardTableViewCell.swift
//  Fight Judge
//
//  Created by 森川正崇 on 2019/09/19.
//  Copyright © 2019 morikawamasataka. All rights reserved.
//

import UIKit

protocol FightCardTableViewCellDelegate {
    func vote(tableViewCell: UITableViewCell, button: UIButton)
    func watchPrediction(tableViewCell: UITableViewCell, button: UIButton)
    func writePrediction(tableViewCell: UITableViewCell, button: UIButton)
    func buyPPV(tableViewCell: UITableViewCell, button: UIButton)
    func buyTicket(tableViewCell: UITableViewCell, button: UIButton)
    func watchNews(tableViewCell: UITableViewCell, button: UIButton)
    func notice(tableViewCell: UITableViewCell, button: UIButton)
}

class FightCardTableViewCell: UITableViewCell {
    
    var delegate : FightCardTableViewCellDelegate?
    @IBOutlet var leftFighterImageView: UIImageView!
    @IBOutlet var rightFighterImageView: UIImageView!
    @IBOutlet var leftFigterLabel: UILabel!
    @IBOutlet var rightFighterLabel: UILabel!
    @IBOutlet var leftFighterAgeLabel: UILabel!
    @IBOutlet var rightFighterAgeLabel: UILabel!
    @IBOutlet var leftFighterResultsLabel: UILabel!
    @IBOutlet var rightFighterResultsLabel: UILabel!
    @IBOutlet var leftFighterFinishRateLabel: UILabel!
    @IBOutlet var rightFighterFinishRateLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet var noticeButton: UIButton!
    @IBOutlet var voteButton: UIButton!
    @IBOutlet var wrightPredictionButton: UIButton!
    @IBOutlet var watchPredictionButton: UIButton!
    @IBOutlet var buyPPVButton: UIButton!
    @IBOutlet var buyTicketButton: UIButton!
    @IBOutlet var watchNewsButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //角丸の程度を指定
        self.watchPredictionButton.layer.cornerRadius = 10.0
        watchPredictionButton.layer.shadowColor = UIColor.black.cgColor
        watchPredictionButton.layer.shadowOpacity = 0.5 // 透明度
        watchPredictionButton.layer.shadowOffset = CGSize(width: 5, height: 5) // 距離
        watchPredictionButton.layer.shadowRadius = 10 // ぼかし量
        self.wrightPredictionButton.layer.cornerRadius = 10.0
        wrightPredictionButton.layer.shadowColor = UIColor.black.cgColor
        wrightPredictionButton.layer.shadowOpacity = 0.5 // 透明度
        wrightPredictionButton.layer.shadowOffset = CGSize(width: 5, height: 5) // 距離
        wrightPredictionButton.layer.shadowRadius = 10 // ぼかし量
        self.voteButton.layer.cornerRadius = 10.0
        voteButton.layer.shadowColor = UIColor.black.cgColor
        voteButton.layer.shadowOpacity = 0.5 // 透明度
        voteButton.layer.shadowOffset = CGSize(width: 5, height: 5) // 距離
        voteButton.layer.shadowRadius = 10 // ぼかし量
        self.noticeButton.layer.cornerRadius = 10.0
        noticeButton.layer.shadowColor = UIColor.black.cgColor
        noticeButton.layer.shadowOpacity = 0.5 // 透明度
        noticeButton.layer.shadowOffset = CGSize(width: 5, height: 5) // 距離
        noticeButton.layer.shadowRadius = 10 // ぼかし量
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    
    
    @IBAction func notice(button: UIButton) {
        self.delegate?.notice(tableViewCell: self, button: button)
    }
    
    @IBAction func vote(button: UIButton) {
        self.delegate?.vote(tableViewCell: self, button: button)
    }
    
    @IBAction func writePrediction(button: UIButton) {
        self.delegate?.writePrediction(tableViewCell: self, button: button)
    }
    
    @IBAction func watchPrediction(button: UIButton) {
        self.delegate?.watchPrediction(tableViewCell: self, button: button)
    }
    
    @IBAction func buyPPV(button: UIButton) {
        self.delegate?.buyPPV(tableViewCell: self, button: button)
    }
    
    @IBAction func buyTicket(button: UIButton) {
        self.delegate?.buyTicket(tableViewCell: self, button: button)
    }
    
    @IBAction func watchNews(button: UIButton) {
        self.delegate?.watchNews(tableViewCell: self, button: button)
    }
    
}
