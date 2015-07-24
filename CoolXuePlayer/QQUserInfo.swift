
//
//  QQUserInfo.swift
//  CoolXuePlayer
//
//  Created by lion-mac on 15/7/14.
//  Copyright (c) 2015年 lion-mac. All rights reserved.
//

import UIKit

class QQUserInfo: NSObject {
    var nickname:String = ""
    var is_lost:Int = 0
    var gender:String = ""
    var province:String = ""
    var city:String = ""
    var vip:Int = 0
    var is_yellow_vip:Int = 0
    var yellow_vip_level:Int = 0
    var is_yellow_year_vip:Int = 0
    var figureurl:String = ""       //30
    var figureurl_qq_1:String = ""  //40
    var figureurl_1:String = ""     //50
    var figureurl_2:String = ""     //100
    var level:Int = 0
    init(dictQQUser: NSDictionary) {
        super.init()
        self.setQQUserInfo(dictQQUser)
    }
    func setQQUserInfo(dictQQUser:NSDictionary){
        var nickname:String! = dictQQUser["nickname"] as? String
        var is_lost:Int! = dictQQUser["is_lost"] as? Int
        var gender:String! = dictQQUser["gender"] as? String
        var province:String! = dictQQUser["province"] as? String
        var city:String! = dictQQUser["city"] as? String
        var vip:Int! = dictQQUser["vip"] as? Int
        var is_yellow_vip:Int! = dictQQUser["is_yellow_vip"] as? Int
        var yellow_vip_level:Int! = dictQQUser["yellow_vip_level"] as? Int
        var is_yellow_year_vip:Int! = dictQQUser["is_yellow_year_vip"] as? Int
        var figureurl:String! = dictQQUser["figureurl"] as? String
        var figureurl_qq_1:String! = dictQQUser["figureurl_qq_1"] as? String
        var figureurl_1:String! = dictQQUser["figureurl_qq_1"] as? String
        var figureurl_2:String! = dictQQUser["figureurl_qq_1"] as? String
        var level:Int! = dictQQUser["figureurl_qq_1"] as? Int
        
        self.nickname = (nickname != nil) ? nickname : self.nickname
        self.is_lost = (is_lost != nil) ? is_lost : self.is_lost
        self.gender = (gender != nil) ? gender : self.gender
        self.province = (province != nil) ? province : self.province
        self.city = (city != nil) ? city : self.city
        self.vip = (vip != nil) ? vip : self.vip
        self.is_yellow_vip = (is_yellow_vip != nil) ? is_yellow_vip : self.is_yellow_vip
        self.yellow_vip_level = (yellow_vip_level != nil) ? yellow_vip_level : self.yellow_vip_level
        self.is_yellow_year_vip = (is_yellow_year_vip != nil) ? is_yellow_year_vip : self.is_yellow_year_vip
        self.figureurl = (figureurl != nil) ? figureurl : self.figureurl
        self.figureurl_qq_1 = (figureurl_qq_1 != nil) ? figureurl_qq_1 : self.figureurl_qq_1
        self.figureurl_1 = (figureurl_1 != nil) ? figureurl_1 : self.figureurl_1
        self.figureurl_2 = (figureurl_2 != nil) ? figureurl_2 : self.figureurl_2
        self.level = (level != nil) ? level : self.level
    }
}
