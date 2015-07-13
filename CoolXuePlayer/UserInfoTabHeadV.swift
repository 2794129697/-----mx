//
//  UserInfoTabHeadV.swift
//  CoolXuePlayer
//
//  Created by lion-mac on 15/7/13.
//  Copyright (c) 2015年 lion-mac. All rights reserved.
//

import UIKit

class UserInfoTabHeadV: UIView {
    //静态属性
    class var getUserInfoTabHeadV:UserInfoTabHeadV{
        get{
            return NSBundle.mainBundle().loadNibNamed("UserInfoTabHeadV", owner: nil, options: nil).first as! UserInfoTabHeadV
        }
    }
    @IBOutlet weak var bnUserMessage: UIButton!
    @IBOutlet weak var userScoreLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var bnUserHead: UIButton!
    //站内信回调
    var messageCallBack:(()->Void)?
    @IBAction func bnUserMessageClicked(sender: UIButton) {
        self.messageCallBack!()
    }
    //登录回调
    var headCallBack:(()->Void)?
    @IBAction func bnUserHeadClicked(sender: UIButton){
        self.headCallBack!()
    }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
