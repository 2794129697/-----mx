//
//  QQLogin.swift
//  CoolXuePlayer
//
//  Created by lion-mac on 15/7/14.
//  Copyright (c) 2015年 lion-mac. All rights reserved.
//

import UIKit

class QQLogin: NSObject,TencentSessionDelegate {
    //静态属性
//    class var qqOAuthPermissions:Array<String>{
//        get{
//            return ["get_user_info"]
//        }
//    }
    override init(){
        super.init()
        if self.tencentOAuth == nil {
            //101155101可以测试
            //100482224
            self.tencentOAuth = TencentOAuth(appId: "100482224", andDelegate: self)
        }
    }
    var qqOAuthPermissions = ["get_user_info"]
    var tencentOAuth:TencentOAuth!
    var authorizeCallBack:((cancelled:Bool,loginSucceed:Bool)->Void)?
    var qqGetUserInfoResponseCallBack:((response: APIResponse)->Void)?
    //授权
    func authorize(authorizeCallBack:(cancelled:Bool,loginSucceed:Bool)->Void){
        self.authorizeCallBack = authorizeCallBack
        //        if TencentOAuth.iphoneQQInstalled() == false{
        //            alertView.message = "手机上木有安装手机QQ"
        //            alertView.show()
        //            return
        //        }else if TencentOAuth.iphoneQQSupportSSOLogin() == false{
        //            alertView.message = "手机上的手机QQ不支持SSO登录"
        //            alertView.show()
        //            return
        //        }
        tencentOAuth.authorize(qqOAuthPermissions, inSafari: false)
    }
    //获取用户信息
    func getUserInfo(qqGetUserInfoResponseCallBack:(response: APIResponse)->Void){
        self.qqGetUserInfoResponseCallBack = qqGetUserInfoResponseCallBack
        self.tencentOAuth.getUserInfo()
    }
    
    //必须实现以下3个方法
    func tencentDidNotLogin(cancelled:Bool) {
        self.authorizeCallBack!(cancelled:cancelled,loginSucceed:false)
    }
    
    func tencentDidLogin() {
        self.authorizeCallBack!(cancelled:false,loginSucceed:true)
    }
    
    func tencentDidNotNetWork(){
        println("无网络连接，请设置网络")
        D3Notice.showText("无网络连接，请设置网络",time:D3Notice.longTime,autoClear:true)
    }
    
    //获取用户信息
    func getUserInfoResponse(response: APIResponse!) {
        self.qqGetUserInfoResponseCallBack!(response:response)
    }
}
