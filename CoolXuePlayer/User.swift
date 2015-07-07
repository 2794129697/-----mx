//
//  User.swift
//  CoolXuePlayer
//
//  Created by lion-mac on 15/6/17.
//  Copyright (c) 2015年 lion-mac. All rights reserved.
//

import Foundation
class User:NSObject{
    var address:String?
    var admin:Bool?
    var answerNum:Int?
    var avatar:String?
    var blogNum:Int?
    var defaultAvatar:String?
    var email:String?
    var firstName:String?
    var id:Int?
    var identify:String?
    var income:Int?
    var ingot:Int?
    var job:Int?
    var key:String?
    var lastName:String?
    var lastTime:Int32?
    var lvl:Int?
    var nickName:String?
    var otherUser:Bool?
    var pay:Int?
    var qq:String?
    var questionNum:Int?
    var redeem:Int?
    var redeemRatio:Float?
    var redeemed:Int?
    var regTime:Int32?
    var score:Int?
    var sex:String?
    var signature:String?
    var status:Int?
    var used:Int?
    var username:String?
    
    init(dictUser:NSDictionary){
        self.address = dictUser["address"] as? String
        self.admin = dictUser["admin"] as? Bool
        self.answerNum = dictUser["answerNum"] as? Int
        self.avatar = dictUser["avatar"] as? String
        self.blogNum = dictUser["job"] as? Int
        self.defaultAvatar = dictUser["pay"] as? String
        self.email = dictUser["email"] as? String
        self.firstName = dictUser["firstName"] as? String
        self.id = dictUser["id"] as? Int
        self.identify = dictUser["identify"] as? String
        self.income = dictUser["income"] as? Int
        self.ingot = dictUser["ingot"] as? Int
        self.job = dictUser["job"] as? Int
        self.key = dictUser["key"] as? String
        self.lastName = dictUser["lastName"] as? String
        self.lastTime = dictUser["lastTime"] as? Int32
        self.lvl = dictUser["lvl"] as? Int
        self.nickName = dictUser["nickName"] as? String
        self.otherUser = dictUser["otherUser"] as? Bool
        self.pay = dictUser["pay"] as? Int
        self.qq = dictUser["qq"] as? String
        self.questionNum = dictUser["questionNum"] as? Int
        self.redeem = dictUser["redeem"] as? Int
        self.redeemRatio = dictUser["redeemRatio"] as? Float
        self.redeemed = dictUser["redeemed"] as? Int
        self.regTime = dictUser["regTime"] as? Int32
        self.score = dictUser["score"] as? Int
        self.sex = dictUser["sex"] as? String
        self.signature = dictUser["signature"] as? String
        self.status = dictUser["status"] as? Int
        self.used = dictUser["used"] as? Int
        self.username = dictUser["username"] as? String
    }
}