
//
//  MoviePo.swift
//  CoolXuePlayer
//
//  Created by lion-mac on 15/6/1.
//  Copyright (c) 2015年 lion-mac. All rights reserved.
//

import Foundation
class MoviePO: NSObject {
    var title:String!
    var img:String!
    var desc:String!
    
    
    init(dict:NSMutableDictionary){
        super.init()
        self.movePOWithDict(dict)
    }
    
    func movePOWithDict(dict:NSMutableDictionary){
        self.title = dict["title"] as! String
        self.img = dict["img"] as! String
        self.desc = dict["desc"] as! String
    }
}
