//
//  User.swift
//  Fight Judge
//
//  Created by 森川正崇 on 2019/10/21.
//  Copyright © 2019 morikawamasataka. All rights reserved.
//

import UIKit

class User: NSObject {
    var objectId: String
    var userName: String
    var displayName: String?
    var introduction: String?

    init(objectId: String, userName: String) {
        self.objectId = objectId
        self.userName = userName
    }
}
