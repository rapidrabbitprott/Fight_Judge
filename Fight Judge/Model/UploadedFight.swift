//
//  UploadedFightPrediction.swift
//  Fight Judge
//
//  Created by 森川正崇 on 2019/10/21.
//  Copyright © 2019 morikawamasataka. All rights reserved.
//

import UIKit

class UploadedFight: NSObject {
    
    var objectId: String
    var user: User
    var fightCard: String
    var fightDate: String
    var prediction: String
    var title: String
    var userName: String
    var userObjectId: String
    var createDate: Date
    var isLiked: Bool?
    var commentsToPredictions: [CommentToPredictions]?
    var likeCount : Int = 0
    var type: String
    var ppvURL : String?
    var ticketURL : String?
    
    init(objectId: String, user: User, fightCard:String, fightDate:String, prediction:String, title:String, userName: String, userObjectId:String, createDate:Date, type:String) {
        
        self.objectId = objectId
        self.user = user
        self.fightCard = fightCard
        self.fightDate = fightDate
        self.prediction = prediction
        self.title = title
        self.userName = userName
        self.userObjectId = userObjectId
        self.createDate = createDate
        self.type = type
    }
    
}
