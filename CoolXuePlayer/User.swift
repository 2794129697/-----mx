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
    
    init(dictChannel:NSDictionary){
        self.address = dictChannel["address"] as? String
        self.admin = dictChannel["admin"] as? Bool
        self.answerNum = dictChannel["answerNum"] as? Int
        self.avatar = dictChannel["avatar"] as? String
        self.blogNum = dictChannel["job"] as? Int
        self.defaultAvatar = dictChannel["pay"] as? String
        self.email = dictChannel["email"] as? String
        self.firstName = dictChannel["firstName"] as? String
        self.id = dictChannel["id"] as? Int
        self.identify = dictChannel["identify"] as? String
        self.income = dictChannel["income"] as? Int
        self.ingot = dictChannel["ingot"] as? Int
        self.job = dictChannel["job"] as? Int
        self.key = dictChannel["key"] as? String
        self.lastName = dictChannel["lastName"] as? String
        self.lastTime = dictChannel["lastTime"] as? Int32
        self.lvl = dictChannel["lvl"] as? Int
        self.nickName = dictChannel["nickName"] as? String
        self.otherUser = dictChannel["otherUser"] as? Bool
        self.pay = dictChannel["pay"] as? Int
        self.qq = dictChannel["qq"] as? String
        self.questionNum = dictChannel["questionNum"] as? Int
        self.redeem = dictChannel["redeem"] as? Int
        self.redeemRatio = dictChannel["redeemRatio"] as? Float
        self.redeemed = dictChannel["redeemed"] as? Int
        self.regTime = dictChannel["regTime"] as? Int32
        self.score = dictChannel["score"] as? Int
        self.sex = dictChannel["sex"] as? String
        self.signature = dictChannel["signature"] as? String
        self.status = dictChannel["status"] as? Int
        self.used = dictChannel["used"] as? Int
        self.username = dictChannel["username"] as? String
    }
}