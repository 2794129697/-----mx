//
//  Channel.swift
//  CoolXuePlayer
//
//  Created by lion-mac on 15/5/29.
//  Copyright (c) 2015年 lion-mac. All rights reserved.
//

import UIKit
class Channel:NSObject{
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
    
    init(dictChannel:NSDictionary){
        super.init()
        self.setChannel(dictChannel)
    }
    
    func setChannel(dictChannel:NSDictionary){
        var affix = dictChannel["affix"] as? String
        var author = dictChannel["author"] as? String
        var cover = dictChannel["cover"] as? String
        var createTime = dictChannel["createTime"] as? String
        var defaultCover = dictChannel["defaultCover"] as? String
        var desc = dictChannel["description"] as? String
        var id = dictChannel["id"] as? Int
        var name = dictChannel["name"] as? String
        var playCost = dictChannel["playCost"] as? Int
        var tags = dictChannel["tags"] as? String
        
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
    }
}