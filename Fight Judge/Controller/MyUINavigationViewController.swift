//
//  MyUINavigationViewController.swift
//  Fight Judge
//
//  Created by 森川正崇 on 2019/11/19.
//  Copyright © 2019 morikawamasataka. All rights reserved.
//

import UIKit

class MyUINavigationViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        //　ナビゲーションバーの背景色
        navigationBar.barTintColor = UIColor(red: 255/255, green: 1/255, blue: 1/255, alpha: 1)
        // ナビゲーションバーのアイテムの色　（戻る　＜　とか　読み込みゲージとか）
        navigationBar.tintColor = .white
        // ナビゲーションバーのテキストを変更する
        navigationBar.titleTextAttributes = [
            // 文字の色
            .foregroundColor: UIColor.white
        ]
    }
    

    

}
