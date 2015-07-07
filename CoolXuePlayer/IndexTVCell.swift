//
//  VedioDescTheAlbumTVCell.swift
//  CoolXuePlayer
//
//  Created by lion-mac on 15/7/4.
//  Copyright (c) 2015年 lion-mac. All rights reserved.
//

import UIKit

class IndexTVCell: UITableViewCell {
    @IBOutlet weak var palyTimesLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var vedioImage: UIImageView!

    @IBOutlet weak var playCostLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
