//
//  VedioDescTheAlbumTVCell.swift
//  CoolXuePlayer
//
//  Created by lion-mac on 15/7/4.
//  Copyright (c) 2015年 lion-mac. All rights reserved.
//

import UIKit
protocol HistoryTVCellDelegate{
    func playVedio(vedio:Vedio)
}
class HistoryTVCell: UITableViewCell {
    @IBOutlet weak var palyTimesLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var vedioImage: UIImageView!
    var vedio:Vedio?
    var delegate:HistoryTVCellDelegate?
    @IBAction func bnPlayVideo(sender: UIButton) {
        if self.vedio != nil {
            self.delegate?.playVedio(self.vedio!)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
