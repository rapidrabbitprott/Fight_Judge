//
//  SearchUserTableViewCell.swift
//  Fight Judge
//
//  Created by 森川正崇 on 2019/11/12.
//  Copyright © 2019 morikawamasataka. All rights reserved.
//

import UIKit

protocol SearchUserTableViewCellDelegate {
    func didTapFollowButton(tableViewCell: UITableViewCell, button: UIButton)
}

class SearchUserTableViewCell: UITableViewCell {
    
    var delegate: SearchUserTableViewCellDelegate?
    
    @IBOutlet var userImageView: UIImageView!
    @IBOutlet var selfIntroduceLabel: UILabel!
    @IBOutlet var displayNameLabel: UILabel!
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var followButton: UIButton!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func tapFollowButton(button: UIButton) {
        self.delegate?.didTapFollowButton(tableViewCell: self, button: button)
    }
    
}
