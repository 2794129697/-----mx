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
    @IBOutlet weak var userIdTextField: UITextField!
    @IBOutlet weak var pwdTextField: UITextField!
    var alertView:UIAlertView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.tabBarController?.delegate = self
        //self.navigationController?.navigationBar.delegate = self
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.Plain, target: self, action: "fnNavBackClicked")
    }
    func navigationBar(navigationBar: UINavigationBar, didPopItem item: UINavigationItem) {
        println("233qa")
    }
    func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
        println("xx")
    }
    func fnNavBackClicked(){
        if LoginTool.isNeedUserLogin {
            self.navigationController?.popToRootViewControllerAnimated(true)
        }else{
            self.navigationController?.popViewControllerAnimated(true)
        }
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
