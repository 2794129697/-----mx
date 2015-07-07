//
//  Vedio.swift
//  CoolXuePlayer
//
//  Created by lion-mac on 15/5/29.
//  Copyright (c) 2015年 lion-mac. All rights reserved.
//

import UIKit
class Vedio:NSObject{
    var affix:String! = ""
    var author:String! = ""
    var cover:String! = ""
    var createTime:String! = ""
    var defaultCover:String! = ""
    var desc:String! = ""
    var id:Int! = 0
    var name:String! = ""
    var playCost:Int! = 0
    var tags:String! = ""
    var vedioUrl:String! = ""
    var playTimes:Int! = 0
    
    init(dictVedio:NSDictionary){
        super.init()
        self.setVedio(dictVedio)
    }
    
    func setVedio(dictVedio:NSDictionary){
        var affix = dictVedio["affix"] as? String
        var author = dictVedio["author"] as? String
        var cover = dictVedio["cover"] as? String
        var createTime = dictVedio["createTime"] as? String
        var defaultCover = dictVedio["defaultCover"] as? String
        var desc = dictVedio["description"] as? String
        var id = dictVedio["id"] as? Int
        var name = dictVedio["name"] as? String
        var playCost = dictVedio["playCost"] as? Int
        var tags = dictVedio["tags"] as? String
        var playTimes = dictVedio["playTimes"] as? Int
        
        self.affix = (affix != nil) ? affix : self.affix
        self.author = (author != nil) ? author : self.author
        self.cover = (cover != nil) ? cover : self.cover
        self.createTime = (createTime != nil) ? createTime : self.createTime
        self.defaultCover = (defaultCover != nil) ? defaultCover : self.defaultCover
        self.desc = (desc != nil) ? desc : self.desc
        self.id = (id != nil) ? id : self.id
        self.name = (name != nil) ? name : self.name
        self.playCost = (playCost != nil) ? playCost : self.playCost
        self.tags = (tags != nil) ? tags : self.tags
        self.playTimes = (playTimes != nil) ? playTimes : self.playTimes
    }
}