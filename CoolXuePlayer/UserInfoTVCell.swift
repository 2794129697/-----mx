//
//  UserInfoTVC.swift
//  CoolXuePlayer
//
//  Created by lion-mac on 15/7/13.
//  Copyright (c) 2015年 lion-mac. All rights reserved.
//

import UIKit

class UserInfoTVCell: UITableViewCell {
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
