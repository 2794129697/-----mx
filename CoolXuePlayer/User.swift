//
//  User.swift
//  CoolXuePlayer
//
//  Created by lion-mac on 15/6/17.
//  Copyright (c) 2015年 lion-mac. All rights reserved.
//

import Foundation
class User:NSObject{
    var address:String = ""
    var admin:Bool = false
    var answerNum:Int = 0
    var avatar:String = ""
    var blogNum:Int = 0
    var defaultAvatar:String = ""
    var email:String = ""
    var firstName:String = ""
    var id:Int = 0
    var identify:String = ""
    var income:Int = 0
    var ingot:Int = 0
    var job:Int = 0
    var key:String = ""
    var lastName:String = ""
    var lastTime:Int32 = 0
    var lvl:Int = 0
    var nickName:String = ""
    var otherUser:Bool = false
    var pay:Int = 0
    var qq:String = ""
    var questionNum:Int = 0
    var redeem:Int = 0
    var redeemRatio:Float = 0.0
    var redeemed:Int = 0
    var regTime:Int32 = 0
    var score:Int = 0
    var sex:String = ""
    var signature:String = ""
    var status:Int = 0
    var used:Int = 0
    var username:String = ""
    override init(){
        
    }
   func setUserInfo(dictUser:NSDictionary){
        var address:String! = dictUser["address"] as? String
        var admin:Bool! = dictUser["admin"] as? Bool
        var answerNum:Int! = dictUser["answerNum"] as? Int
        var avatar:String! = dictUser["avatar"] as? String
        var blogNum:Int! = dictUser["job"] as? Int
        var defaultAvatar:String! = dictUser["pay"] as? String
        var email:String! = dictUser["email"] as? String
        var firstName:String! = dictUser["firstName"] as? String
        var id:Int! = dictUser["id"] as? Int
        var identify:String! = dictUser["identify"] as? String
        var income:Int! = dictUser["income"] as? Int
        var ingot:Int! = dictUser["ingot"] as? Int
        var job:Int! = dictUser["job"] as? Int
        var key:String! = dictUser["key"] as? String
        var lastName:String! = dictUser["lastName"] as? String
        var lastTime:Int32! = dictUser["lastTime"] as? Int32
        var lvl:Int! = dictUser["lvl"] as? Int
        var nickName:String! = dictUser["nickName"] as? String
        var otherUser:Bool! = dictUser["otherUser"] as? Bool
        var pay:Int! = dictUser["pay"] as? Int
        var qq:String! = dictUser["qq"] as? String
        var questionNum:Int! = dictUser["questionNum"] as? Int
        var redeem:Int! = dictUser["redeem"] as? Int
        var redeemRatio:Float! = dictUser["redeemRatio"] as? Float
        var redeemed:Int! = dictUser["redeemed"] as? Int
        var regTime:Int32! = dictUser["regTime"] as? Int32
        var score:Int! = dictUser["score"] as? Int
        var sex:String! = dictUser["sex"] as? String
        var signature:String! = dictUser["signature"] as? String
        var status:Int! = dictUser["status"] as? Int
        var used:Int! = dictUser["used"] as? Int
        var username:String! = dictUser["username"] as? String
        
        self.address = (address != nil) ? address : self.address
        self.admin = (admin != nil) ? admin : self.admin
        self.answerNum = (answerNum != nil) ? answerNum : self.answerNum
        self.avatar = (avatar != nil) ? avatar : self.avatar
        self.blogNum = (blogNum != nil) ? blogNum : self.blogNum
        self.defaultAvatar = (defaultAvatar != nil) ? defaultAvatar : self.defaultAvatar
        self.email = (email != nil) ? email : self.email
        self.firstName = (firstName != nil) ? firstName : self.firstName
        self.id = (id != nil) ? id : self.id
        self.identify = (identify != nil) ? identify : self.identify
        self.income = (income != nil) ? income : self.income
        self.ingot = (ingot != nil) ? ingot : self.ingot
        self.job = (job != nil) ? job : self.job
        self.key = (key != nil) ? key : self.key
        self.lastName = (lastName != nil) ? lastName : self.lastName
        self.lastTime = (lastTime != nil) ? lastTime : self.lastTime
        self.lvl = (lvl != nil) ? lvl : self.lvl
        self.nickName = (nickName != nil) ? nickName : self.nickName
        self.otherUser = (otherUser != nil) ? otherUser : self.otherUser
        self.pay = (pay != nil) ? pay : self.pay
        self.qq = (qq != nil) ? qq : self.qq
        self.questionNum = (questionNum != nil) ? questionNum : self.questionNum
        self.redeem = (redeem != nil) ? redeem : self.redeem
        self.redeemRatio = (redeemRatio != nil) ? redeemRatio : self.redeemRatio
        self.redeemed = (redeemed != nil) ? redeemed : self.redeemed
        self.regTime = (regTime != nil) ? regTime : self.regTime
        self.score = (score != nil) ? score : self.score
        self.sex = (sex != nil) ? sex : self.sex
        self.signature = (signature != nil) ? signature : self.signature
        self.status = (status != nil) ? status : self.status
        self.used = (used != nil) ? used : self.used
        self.username = (username != nil) ? username : self.username
    }
    init(dictUser:NSDictionary){
        super.init()
        self.setUserInfo(dictUser)
    }
}