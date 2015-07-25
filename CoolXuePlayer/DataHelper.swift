//
//  DataHelper.swift
//  CoolXuePlayer
//
//  Created by lion-mac on 15/7/25.
//  Copyright (c) 2015年 lion-mac. All rights reserved.
//

import Foundation
public class DataHelper{
    //保存
    public class func CacheData(cache_file_path:String,data:AnyObject)->Bool{
        //将文件保存到本地(暂时理解为加压保存，使用时需解压)
        var path = NSHomeDirectory()+cache_file_path
        return NSKeyedArchiver.archiveRootObject(data, toFile: path)
    }
    //读取
    public class func ReadDate(cache_file_path:String)->NSDictionary{
        var dict:NSDictionary! = NSDictionary()
        var path:String = NSHomeDirectory()+cache_file_path
        println("localFilePath=\n\(path)")
        //判断本地是否存在该文件
        var is_exists = NSFileManager.defaultManager().fileExistsAtPath(path)
        println("is_exists = \(is_exists)\n")
        //read local file
        if is_exists{
            var data : NSData! = NSData(contentsOfFile: path)!
            //解压数据
            data = NSKeyedUnarchiver.unarchiveObjectWithFile(path) as? NSData
            if data != nil {
                dict = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: nil) as!NSDictionary
            }
        }
        return dict
    }
    public class func getVideoList(dict:NSDictionary)->Array<AnyObject>{
        var list:Array<Vedio>! = []
        var c_array:NSArray! = dict["data"] as? NSArray
        if c_array != nil && c_array.count > 0 {
            for dict in c_array{
                var vedioModel = Vedio(dictVedio: dict as! NSDictionary)
                list.append(vedioModel)
            }
        }
        return list
    }
    
    public class func getVideoCategoryList(dict:NSDictionary)->Array<AnyObject>{
        var list:Array<Category>! = []
        var c_array:NSArray! = dict["data"] as? NSArray
        if c_array != nil && c_array.count > 0 {
            for dict in c_array{
                var categoryModel = Category(dict: dict as! NSDictionary)
                list.append(categoryModel)
            }
        }
        return list
    }

}
