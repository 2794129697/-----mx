//
//  ScrollContent.swift
//  CoolXuePlayer
//
//  Created by lion-mac on 15/6/2.
//  Copyright (c) 2015年 lion-mac. All rights reserved.
//

import Foundation
import UIKit
class ScrollContentView: UIView {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    //静态属性
    class var scrollContentView:ScrollContentView{
        get{
            return NSBundle.mainBundle().loadNibNamed("ScrollContentView", owner: nil, options: nil).first as! ScrollContentView
        }
    }
    
}