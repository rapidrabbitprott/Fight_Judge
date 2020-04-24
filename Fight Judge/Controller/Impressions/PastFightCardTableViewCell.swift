//
//  PastFightCardTableViewCell.swift
//  Fight Judge
//
//  Created by 森川正崇 on 2019/11/11.
//  Copyright © 2019 morikawamasataka. All rights reserved.
//

import UIKit

protocol PastFightCardTableViewCellDelegate {
    func watchVote(tableViewCell: UITableViewCell, button: UIButton)
    func watchImpression(tableViewCell: UITableViewCell, button: UIButton)
    func writeImpression(tableViewCell: UITableViewCell, button: UIButton)
    func watchVideoButtonTaped(tableViewCell: UITableViewCell, button: UIButton)
    func watchNewsButtonTaped(tableViewCell: UITableViewCell, button: UIButton)
}


class PastFightCardTableViewCell: UITableViewCell {
    
    var delegate : PastFightCardTableViewCellDelegate?
    @IBOutlet var leftFighterImageView: UIImageView!
    @IBOutlet var rightFighterImageView: UIImageView!
    @IBOutlet var leftFighterLabel: UILabel!
    @IBOutlet var rightFighterLabel: UILabel!
    @IBOutlet var leftFighterAgeLabel: UILabel!
    @IBOutlet var rightFighterAgeLabel: UILabel!
    @IBOutlet var leftFighterResultsLabel: UILabel!
    @IBOutlet var rightFighterResultsLabel: UILabel!
    @IBOutlet var leftFighterFinishRateLabel: UILabel!
    @IBOutlet var rightFighterFinishRateLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet var watchImpressionButton: UIButton!
    @IBOutlet var watchvoteButton: UIButton!
    @IBOutlet var wrightImpressionButton: UIButton!
    @IBOutlet var watchNewsButton: UIButton!
    @IBOutlet var watchVideoButton: UIButton!
    @IBOutlet var favoButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.watchImpressionButton.layer.cornerRadius = 10.0
        watchImpressionButton.layer.shadowColor = UIColor.black.cgColor
        watchImpressionButton.layer.shadowOpacity = 0.5 // 透明度
        watchImpressionButton.layer.shadowOffset = CGSize(width: 5, height: 5) // 距離
        watchImpressionButton.layer.shadowRadius = 10 // ぼかし量
        self.watchvoteButton.layer.cornerRadius = 10.0
        watchvoteButton.layer.shadowColor = UIColor.black.cgColor
        watchvoteButton.layer.shadowOpacity = 0.5 // 透明度
        watchvoteButton.layer.shadowOffset = CGSize(width: 5, height: 5) // 距離
        watchvoteButton.layer.shadowRadius = 10 // ぼかし量
        self.wrightImpressionButton.layer.cornerRadius = 10.0
        wrightImpressionButton.layer.shadowColor = UIColor.black.cgColor
        wrightImpressionButton.layer.shadowOpacity = 0.5 // 透明度
        wrightImpressionButton.layer.shadowOffset = CGSize(width: 5, height: 5) // 距離
        wrightImpressionButton.layer.shadowRadius = 10 // ぼかし量
        self.favoButton.layer.cornerRadius = 10.0
        favoButton.layer.shadowColor = UIColor.black.cgColor
        favoButton.layer.shadowOpacity = 0.5 // 透明度
        favoButton.layer.shadowOffset = CGSize(width: 5, height: 5) // 距離
        favoButton.layer.shadowRadius = 10 // ぼかし量
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func watchVote(button: UIButton) {
        self.delegate?.watchVote(tableViewCell: self, button: button)
    }
    
    @IBAction func writeImpression(button: UIButton) {
        self.delegate?.writeImpression(tableViewCell: self, button: button)
    }
    
    @IBAction func watchImpression(button: UIButton) {
        self.delegate?.watchImpression(tableViewCell: self, button: button)
    }
    
    @IBAction func watchVideo(button: UIButton) {
        self.delegate?.watchVideoButtonTaped(tableViewCell: self, button: button)
    }
    @IBAction func watchNews(button: UIButton) {
        self.delegate?.watchNewsButtonTaped(tableViewCell: self, button: button)
    }
    
}
