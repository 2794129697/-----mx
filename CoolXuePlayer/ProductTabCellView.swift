//
//  ProductTabCellView.swift
//  CoolXuePlayer
//
//  Created by lion-mac on 15/6/30.
//  Copyright (c) 2015年 lion-mac. All rights reserved.
//

import UIKit

class ProductTabCellView: UITableViewCell {
   
    @IBOutlet weak var pImage: UIImageView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    //静态属性
    class var GetProductTabCellView:ProductTabCellView{
        get{
            return NSBundle.mainBundle().loadNibNamed("ProductTableCell", owner: nil, options: nil).first as! ProductTabCellView
        }
    }
    /*
        // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
