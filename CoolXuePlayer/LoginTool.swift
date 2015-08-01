//
//  LoginTool.swift
//  CoolXuePlayer
//
//  Created by lion-mac on 15/7/7.
//  Copyright (c) 2015年 lion-mac. All rights reserved.
//

import UIKit
enum LoginType{
    case None,QQ,Sina
}
class LoginTool: NSObject {
    static var isLogin:Bool = false
    static var isAutoLogin:Bool = false
    static var isNeedUserLogin:Bool = false
    static var loginType:LoginType = .None
    static func autoLogin(){
        var userAccount:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        var is_login:Bool? = userAccount.objectForKey("is_login") as? Bool
        var uid:String? = userAccount.objectForKey("uid") as? String
        var upwd:String? = userAccount.objectForKey("upwd") as? String
        if uid != nil && upwd != nil {
            self.Login(uid,upwd: upwd)
            self.isAutoLogin = true
        }else{
            self.isNeedUserLogin = true
        }
    }
    static func Login(uid:String?,upwd:String?){
        if uid != nil && upwd != nil {
            var url = "http://www.icoolxue.com/account/login"
            var bodyParam:Dictionary = ["username":uid!,"password":upwd!]
            HttpManagement.requestttt(url, method: "POST",bodyParam: bodyParam,headParam:nil) { (repsone:NSHTTPURLResponse,data:NSData) -> Void in
                var bdict:NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: nil) as!NSDictionary
                println(bdict)
                var code:Int = bdict["code"] as! Int
                if HttpManagement.HttpResponseCodeCheck(code, viewController: nil){
                    var userAccount:NSUserDefaults = NSUserDefaults.standardUserDefaults()
                    self.isLogin = true
                    self.isAutoLogin = true
                }else{
                    self.isLogin = false
                }
            }
        }
    }
}
