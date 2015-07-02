//
//  Channel.swift
//  CoolXuePlayer
//
//  Created by lion-mac on 15/5/29.
//  Copyright (c) 2015年 lion-mac. All rights reserved.
//

import UIKit
class Channel:NSObject{
    var affix:String!
    var author:String!
    var cover:String!
    var createTime:String!
    var defaultCover:String!
    var desc:String!
    var id:Int!
    var name:String!
    var playCost:Int!
    var tags:String!
    var vedioUrl:String!
    
    init(dictChannel:NSDictionary){
        self.affix = dictChannel["affix"] as? String
        self.author = dictChannel["author"] as? String
        self.cover = dictChannel["cover"] as? String
        self.createTime = dictChannel["createTime"] as? String
        self.defaultCover = dictChannel["defaultCover"] as? String
        self.desc = dictChannel["description"] as? String
        self.id = dictChannel["id"] as? Int
        self.name = dictChannel["name"] as? String
        self.playCost = dictChannel["playCost"] as? Int
        self.tags = dictChannel["tags"] as? String

    }
    
    func setChannel(dictChannel:NSDictionary){
        self.affix = dictChannel["affix"] as? String
        self.author = dictChannel["author"] as? String
        self.cover = dictChannel["cover"] as? String
        self.createTime = dictChannel["createTime"] as? String
        self.defaultCover = dictChannel["defaultCover"] as? String
        self.desc = dictChannel["description"] as? String
        self.id = dictChannel["id"] as? Int
        self.name = dictChannel["name"] as? String
        self.playCost = dictChannel["playCost"] as? Int
        self.tags = dictChannel["tags"] as? String
    }
}