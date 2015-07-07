//
//  UserInfoHeadView.swift
//  CoolXuePlayer
//
//  Created by lion-mac on 15/6/17.
//  Copyright (c) 2015年 lion-mac. All rights reserved.
//

import UIKit
protocol UserInfoHeadViewDelegate{
    func loginOrLoginOut()
}
class UserInfoHeadView: UICollectionReusableView {
    var delegate:UserInfoHeadViewDelegate?
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBAction func bnLoginClicked(sender: UIButton) {
        if self.delegate != nil {
            self.delegate?.loginOrLoginOut()
        }
    }
        
}
