//
//  LoginViewController.swift
//  CoolXuePlayer
//
//  Created by lion-mac on 15/6/4.
//  Copyright (c) 2015年 lion-mac. All rights reserved.
//

import UIKit
import Foundation

class LoginViewController: UIViewController,UIAlertViewDelegate,UITextFieldDelegate{
    var qqLogin:QQLogin!
    var qqUserInfo:QQUserInfo!
    @IBOutlet weak var userIdTextField: UITextField!
    @IBOutlet weak var pwdTextField: UITextField!
    var alertView:UIAlertView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func showAlertView(tag _tag:Int,title:String,message:String,delegate:UIAlertViewDelegate,cancelButtonTitle:String){
        if alertView == nil {
            alertView = UIAlertView()
        }
        alertView.title = title
        alertView.message = message
        alertView.delegate = self
        alertView.addButtonWithTitle(cancelButtonTitle)
        alertView.tag = _tag
        alertView.show()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.loginBnClicked("")
        self.userIdTextField.resignFirstResponder()
        self.pwdTextField.resignFirstResponder()
        return true
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        //println("buttonIndex=\(buttonIndex)")
        if alertView.tag == 0 {
            
        }else if alertView.tag == 1 {
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    @IBAction func loginBnClicked(sender: AnyObject) {
        LoginTool.loginType = LoginType.None
        var userid = self.userIdTextField.text
        var upwd = self.pwdTextField.text
//        if userid.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) <= 0 {
//            self.showAlertView(tag: 0,title: "提示", message: "用户名不能为空！", delegate: self, cancelButtonTitle: "确定")
//            return
//        }
//        if upwd.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) <= 0 {
//            self.showAlertView(tag: 0,title: "提示", message: "密码不能为空！", delegate: self, cancelButtonTitle: "确定")
//            return
//        }
        userid = "2794129697@qq.com"
        upwd = "123456"
        var url = "http://www.icoolxue.com/account/login"
        var bodyParam:Dictionary = ["username":userid,"password":upwd]
        HttpManagement.requestttt(url, method: "POST",bodyParam: bodyParam,headParam:nil) { (repsone:NSHTTPURLResponse,data:NSData) -> Void in
            var bdict:NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: nil) as!NSDictionary
            println(bdict)
            var code:Int = bdict["code"] as! Int
            var userAccount:NSUserDefaults = NSUserDefaults.standardUserDefaults()
            if HttpManagement.HttpResponseCodeCheck(code, viewController: self){
                userAccount.setObject(true, forKey: "is_login")
                userAccount.setObject(userid,forKey: "uid")
                userAccount.setObject(upwd,forKey: "upwd")
                LoginTool.isLogin = true
                LoginTool.isNeedUserLogin = false
                self.showAlertView(tag:1,title: "提示", message: "登录成功！", delegate: self, cancelButtonTitle: "确定")
            }else{
                userAccount.removeObjectForKey("uid")
                userAccount.removeObjectForKey("upwd")
                self.showAlertView(tag:0,title: "提示", message: "登录失败！", delegate: self, cancelButtonTitle: "确定")
            }
        }
        
//        var url = "http://www.icoolxue.com/account/login"
//        var param:Dictionary = ["username":"2794129697@qq.com","password":"123456"]
//        HttpManagement.httpTask.POST(url, parameters: param) { (response:HTTPResponse) -> Void in
//            if response.statusCode == 200 {
//                //var str = NSString(data: response.responseObject as!NSData, encoding:NSUTF8StringEncoding)
//                var bdict:NSDictionary = NSJSONSerialization.JSONObjectWithData(response.responseObject as! NSData, options: NSJSONReadingOptions.AllowFragments, error: nil) as!NSDictionary
//                println(bdict)
//                var code:Int = bdict["code"] as! Int
//                if HttpManagement.HttpResponseCodeCheck(code, viewController: self){
//                    var alert:UIAlertView = UIAlertView(title: "提示", message: "登录成功！", delegate: self, cancelButtonTitle: "确定")
//                    alert.show()
//                }
//                
//            }
//        }
    }
    
    //QQ登录
    @IBAction func bnQQLoginClicked(sender: UIButton) {
        if self.qqLogin == nil {
            self.qqLogin = QQLogin()
        }
        LoginTool.loginType = LoginType.QQ
        println("accessToken=====>\(self.qqLogin.tencentOAuth.accessToken)")
        println("expirationDate=====>\(self.qqLogin.tencentOAuth.expirationDate)")
        println("authorizeState=====>\(TencentOAuth.authorizeState)")
        println("authMode=====>\(self.qqLogin.tencentOAuth.authMode)")
        //qq授权
        self.qqLogin.authorize(self.qqAuthorizeCallBack)
    }
    
    //授权回调
    func qqAuthorizeCallBack(cancelled:Bool,loginSucceed:Bool){
        println("\nqqAuthorizeCallBack")
        if loginSucceed {
            if self.qqLogin.tencentOAuth.accessToken != nil{
                D3Notice.showText("登录成功",time:D3Notice.longTime,autoClear:true)
                println("accessToken=\(self.qqLogin.tencentOAuth.accessToken)")//D49FC381ECFDEDA8B72DC8776BC44974
                println("openId=\(self.qqLogin.tencentOAuth.openId)")//FD70E2CF311CCE980467453A4A26FAF4
                println("expirationDate=\(self.qqLogin.tencentOAuth.expirationDate)")//2015-08-13 07:03:49 +0000
                //自己服务登录
                self.qqServerLogin(self.qqLogin.tencentOAuth.openId,accessToken: self.qqLogin.tencentOAuth.accessToken)
                self.qqLogin.getUserInfo(self.qqGetUserInfoResponseCallBack)
            }else{
                println("登录不成功 没有获取accesstoken");
            }
        }else if cancelled {
            println("QQ用户取消登录")
            D3Notice.showText("取消登录",time:D3Notice.longTime,autoClear:true)
        }else{
            println("QQ登录失败")
            D3Notice.showText("登录失败",time:D3Notice.longTime,autoClear:true)
        }
    }
    
    //获取QQ用户信息回调
    func qqGetUserInfoResponseCallBack(response: APIResponse!){
        println("\ngetUserInfoResponseCallBack")
        self.qqUserInfo = QQUserInfo(dictQQUser: response.jsonResponse)
        println("self.qqUserInfo.nickname=\(self.qqUserInfo.nickname)")
    }
    
    func qqServerLogin(openId:String,accessToken:String){
        var url = "http://www.icoolxue.com/qq/login"
        var bodyParam:Dictionary = ["openId":openId,"accessToken":accessToken]
        HttpManagement.requestttt(url, method: "POST",bodyParam: bodyParam,headParam:nil) { (repsone:NSHTTPURLResponse,data:NSData) -> Void in
            var bdict:NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: nil) as!NSDictionary
            println(bdict)
            var code:Int = bdict["code"] as! Int
            var userAccount:NSUserDefaults = NSUserDefaults.standardUserDefaults()
            if HttpManagement.HttpResponseCodeCheck(code, viewController: self){
                userAccount.setObject(true, forKey: "is_login")
                userAccount.setObject(self.qqLogin.tencentOAuth.openId,forKey: "openId")
                userAccount.setObject(self.qqLogin.tencentOAuth.accessToken,forKey: "accessToken")
                LoginTool.isLogin = true
                LoginTool.isNeedUserLogin = false
                self.showAlertView(tag:1,title: "提示", message: "登录成功！", delegate: self, cancelButtonTitle: "确定")
            }else{
                userAccount.removeObjectForKey("openId")
                userAccount.removeObjectForKey("accessToken")
                self.showAlertView(tag:0,title: "提示", message: "登录失败！", delegate: self, cancelButtonTitle: "确定")
            }
        }
    }
    //新浪微博登录

    @IBAction func bnSinaLoginClicked(sender: AnyObject) {
        LoginTool.loginType = LoginType.Sina
        var request: WBAuthorizeRequest! = WBAuthorizeRequest.request() as! WBAuthorizeRequest
        request.redirectURI = "https://api.weibo.com/oauth2/default.html"
        request.scope = "all"
        
        WeiboSDK.sendRequest(request)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
