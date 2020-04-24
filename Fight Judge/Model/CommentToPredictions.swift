//
//  CommentToPredictions.swift
//  Fight Judge
//
//  Created by 森川正崇 on 2019/11/07.
//  Copyright © 2019 morikawamasataka. All rights reserved.
//

import UIKit

class CommentToPredictions: NSObject {
    var postId: String
    var user: User
    var text: String
    var createDate: Date
    
    init(postId: String, user: User, text: String, createDate: Date) {
        self.postId = postId
        self.user = user
        self.text = text
        self.createDate = createDate
    }

}
