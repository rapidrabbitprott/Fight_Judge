//
//  FightPredictionTableViewCell.swift
//  Fight Judge
//
//  Created by 森川正崇 on 2019/09/27.
//  Copyright © 2019 morikawamasataka. All rights reserved.
//

import UIKit

class FightPredictionTableViewCell: UITableViewCell {
    
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var userImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var timestampLabel: UILabel!
    @IBOutlet var smashButton: UIButton!
    @IBOutlet var smashCountLabel: UILabel!
    @IBOutlet var hashTagLabel: UILabel!
    @IBOutlet var predictionimpressionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //角を丸くするコード
        userImageView.layer.cornerRadius = userImageView.bounds.width / 2.0
        userImageView.layer.masksToBounds = true
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
