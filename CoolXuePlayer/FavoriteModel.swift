//
//  FavoriteModel.swift
//  CoolXuePlayer
//
//  Created by lion-mac on 15/7/23.
//  Copyright (c) 2015年 lion-mac. All rights reserved.
//

import Foundation
class FavoriteModel:NSObject{
    var content:String = ""
    var id:Int = 0
    var lastItem:String = ""
    var newAdminReply:Bool = false
    var newUserReply:Bool = false
    var postTime:String = ""
    var status:String = ""
    override init(){
        
    }
    func setUserInfo(dict:NSDictionary){
        var content:String! = dict["content"] as? String
        var id:Int! = dict["id"] as? Int
        var lastItem:String! = dict["lastItem"] as? String
        var newAdminReply:Bool! = dict["newAdminReply"] as? Bool
        var newUserReply:Bool! = dict["newUserReply"] as? Bool
        var postTime:String! = dict["postTime"] as? String
        var status:String! = dict["status"] as? String
        
        self.content = (content != nil) ? content : self.content
        self.id = (id != nil) ? id : self.id
        self.lastItem = (lastItem != nil) ? lastItem : self.lastItem
        self.newAdminReply = (newAdminReply != nil) ? newAdminReply : self.newAdminReply
        self.newUserReply = (newUserReply != nil) ? newUserReply : self.newUserReply
        self.postTime = (postTime != nil) ? postTime : self.postTime
        self.status = (status != nil) ? status : self.status
    }
    init(dict:NSDictionary){
        super.init()
        self.setUserInfo(dict)
    }
}