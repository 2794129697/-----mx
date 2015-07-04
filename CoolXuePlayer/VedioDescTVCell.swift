//
//  VedioDescTVCell.swift
//  CoolXuePlayer
//
//  Created by lion-mac on 15/7/4.
//  Copyright (c) 2015年 lion-mac. All rights reserved.
//

import UIKit

class VedioDescTVCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var playTimesLabel: UILabel!
    @IBOutlet weak var releaseTimeLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
