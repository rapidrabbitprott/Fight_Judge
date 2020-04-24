//
//  PostDetailTableViewCell.swift
//  Fight Judge
//
//  Created by 森川正崇 on 2019/12/05.
//  Copyright © 2019 morikawamasataka. All rights reserved.
//

import UIKit

protocol PostDetailTableViewCellDelegate {
    func smash(tableViewCell: PostDetailTableViewCell, button: UIButton)
    func share(tableViewCell: PostDetailTableViewCell, button: UIButton)
    func buy(tableViewCell: PostDetailTableViewCell, button: UIButton)
}

class PostDetailTableViewCell: UITableViewCell {
    var delegate : PostDetailTableViewCellDelegate?
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var userImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var predictionTextView: UITextView!
    @IBOutlet var timestampLabel: UILabel!
    @IBOutlet var smashButton: UIButton!
    @IBOutlet var buyButton: UIButton!
    @IBOutlet var shareButton: UIButton!
    @IBOutlet var smashCountLabel: UILabel!
    @IBOutlet var smashCountButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //角を丸くするコード
        userImageView.layer.cornerRadius = userImageView.bounds.width / 2.0
        userImageView.layer.masksToBounds = true
        //角丸の程度を指定
        self.smashButton.layer.cornerRadius = 10.0
        smashButton.layer.shadowColor = UIColor.black.cgColor
        smashButton.layer.shadowOpacity = 0.5 // 透明度
        smashButton.layer.shadowOffset = CGSize(width: 5, height: 5) // 距離
        smashButton.layer.shadowRadius = 10 // ぼかし量
        //角丸の程度を指定
        self.buyButton.layer.cornerRadius = 10.0
        buyButton.layer.shadowColor = UIColor.black.cgColor
        buyButton.layer.shadowOpacity = 0.5 // 透明度
        buyButton.layer.shadowOffset = CGSize(width: 5, height: 5) // 距離
        buyButton.layer.shadowRadius = 10 // ぼかし量
        //角丸の程度を指定
        self.shareButton.layer.cornerRadius = 10.0
        shareButton.layer.shadowColor = UIColor.black.cgColor
        shareButton.layer.shadowOpacity = 0.5 // 透明度
        shareButton.layer.shadowOffset = CGSize(width: 5, height: 5) // 距離
        shareButton.layer.shadowRadius = 10 // ぼかし量
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func smash(button: UIButton) {
        self.delegate?.smash(tableViewCell: self, button: button)
    }
    
    @IBAction func share(button: UIButton) {
        self.delegate?.share(tableViewCell: self, button: button)
    }
    
    @IBAction func buy(button: UIButton) {
           self.delegate?.buy(tableViewCell: self, button: button)
       }
}
