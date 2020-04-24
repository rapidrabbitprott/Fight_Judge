//
//  FightImpression.swift
//  Fight Judge
//
//  Created by 森川正崇 on 2019/11/12.
//  Copyright © 2019 morikawamasataka. All rights reserved.
//

import UIKit

class FightImpression: NSObject {
    var objectId: String
    var user: User
    var fightCard: String
    var fightDate: String
    var impression: String
    var title: String
    var userName: String
    var userObjectId: String
    var createDate: Date
    
    
    
    
    
    init(objectId: String, user: User, fightCard:String, fightDate:String, impression:String, title:String, userName: String, userObjectId: String, createDate: Date) {
        
        self.objectId = objectId
        self.user = user
        self.fightCard = fightCard
        self.fightDate = fightDate
        self.impression = impression
        self.title = title
        self.userName = userName
        self.userObjectId = userObjectId
        self.createDate = createDate
        
    }
}
