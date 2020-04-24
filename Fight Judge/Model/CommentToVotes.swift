//
//  CommentToVotes.swift
//  Fight Judge
//
//  Created by 森川正崇 on 2019/11/07.
//  Copyright © 2019 morikawamasataka. All rights reserved.
//

import UIKit

class CommentToVotes: NSObject {
    var user: User
    var text: String
    var createDate: Date
    
    init(user: User, text: String, createDate: Date) {
        self.user = user
        self.text = text
        self.createDate = createDate
    }

}
