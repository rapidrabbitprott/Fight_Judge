//
//  VotePrediction.swift
//  Fight Judge
//
//  Created by 森川正崇 on 2019/10/21.
//  Copyright © 2019 morikawamasataka. All rights reserved.
//

import UIKit

class VotePrediction: NSObject {
    var objectId: String
    var user: User
    var fightCard: String
    var voteAs: String
    var commentsToVotes: [CommentToVotes]?
    
    init(objectId: String, user: User, fightCard:String, voteAs:String) {
           
           self.objectId = objectId
           self.user = user
           self.fightCard = fightCard
           self.voteAs = voteAs
           
           }

}
