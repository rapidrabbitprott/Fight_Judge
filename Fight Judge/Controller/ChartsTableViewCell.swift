//
//  ChartsTableViewCell.swift
//  Fight Judge
//
//  Created by 森川正崇 on 2019/12/09.
//  Copyright © 2019 morikawamasataka. All rights reserved.
//

import UIKit
import Charts

class ChartsTableViewCell: UITableViewCell {
    @IBOutlet var pieChartsView: PieChartView!
    override func awakeFromNib() {
        super.awakeFromNib()
        pieChartsView.translatesAutoresizingMaskIntoConstraints = true
    }
   

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
