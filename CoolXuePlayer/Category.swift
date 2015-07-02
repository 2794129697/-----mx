//
//  Category.swift
//  CoolXuePlayer
//
//  Created by lion-mac on 15/6/18.
//  Copyright (c) 2015年 lion-mac. All rights reserved.
//

import UIKit

class Category: NSObject {
    var subCategoryList:Array<CategorySub>?
    var name:String?
    var value:String?
    init(dict:NSDictionary){
        var subdictList = dict["affixs"] as! Array<NSDictionary>
        self.subCategoryList = []
        for (var i:Int = 0; i < subdictList.count ; i++) {
            var subdict = subdictList[i]
            var subCategory = CategorySub(dict: subdict)
            self.subCategoryList?.append(subCategory)
        }
        self.name = dict["name"] as? String
        self.value = dict["value"] as? String
    }
}
