//
//  CommentToPostTableViewCell.swift
//  Fight Judge
//
//  Created by 森川正崇 on 2019/12/06.
//  Copyright © 2019 morikawamasataka. All rights reserved.
//

import UIKit

protocol CommentTableViewCellDelegate {
    func reply(tableViewCell: UITableViewCell, button: UIButton)
    func like(tableViewCell: UITableViewCell, button: UIButton)
    func dislike(tableViewCell: UITableViewCell, button: UIButton)
    func more(tableViewCell: UITableViewCell, button: UIButton)
}


class CommentTableViewCell: UITableViewCell {
    var delegate : CommentTableViewCellDelegate?
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var userImageView: UIImageView!
    @IBOutlet var commentLabel: UILabel!
    @IBOutlet var timestampLabel: UILabel!
    @IBOutlet var replyButton: UIButton!
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var dislikeButton: UIButton!
    @IBOutlet var moreBUtton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // ユーザー画像を丸く
        userImageView.layer.cornerRadius = userImageView.bounds.width / 2.0
        userImageView.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        userImageView.layer.cornerRadius = userImageView.bounds.width / 2.0
        userImageView.layer.masksToBounds = true
       
    }
    @IBAction func reply(button: UIButton) {
        self.delegate?.reply(tableViewCell: self, button: button)
    }
    
    @IBAction func like(button: UIButton) {
        self.delegate?.like(tableViewCell: self, button: button)
    }
    @IBAction func dislike(button: UIButton) {
        self.delegate?.dislike(tableViewCell: self, button: button)
    }
    @IBAction func more(button: UIButton) {
        self.delegate?.more(tableViewCell: self, button: button)
    }
    
}
