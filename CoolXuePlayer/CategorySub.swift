//
//  Category.swift
//  CoolXuePlayer
//
//  Created by lion-mac on 15/6/18.
//  Copyright (c) 2015年 lion-mac. All rights reserved.
//

import UIKit

class CategorySub: NSObject {
    var cover:String?
    var name:String?
    var value:String?
    init(dict:NSDictionary){
        self.cover = dict["cover"] as? String
        self.name = dict["name"] as? String
        self.value = dict["value"] as? String
    }
}
