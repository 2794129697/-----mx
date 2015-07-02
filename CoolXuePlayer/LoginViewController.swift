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
        println("buttonIndex=\(buttonIndex)")
        if alertView.tag == 0 {
            
        }else if alertView.tag == 1 {
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    @IBAction func loginBnClicked(sender: AnyObject) {
        var userid = self.userIdTextField.text
        var pwd = self.pwdTextField.text
//        if userid.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) <= 0 {
//            self.showAlertView(tag: 0,title: "提示", message: "用户名不能为空！", delegate: self, cancelButtonTitle: "确定")
//            return
//        }
//        if pwd.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) <= 0 {
//            self.showAlertView(tag: 0,title: "提示", message: "密码不能为空！", delegate: self, cancelButtonTitle: "确定")
//            return
//        }
        var url = "http://www.icoolxue.com/account/login"
        var bodyParam:Dictionary = ["username":"2794129697@qq.com","password":"123456"]
        HttpManagement.requestttt(url, method: "POST",bodyParam: bodyParam,headParam:nil) { (repsone:NSHTTPURLResponse,data:NSData) -> Void in
            var bdict:NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: nil) as!NSDictionary
            println(bdict)
            var code:Int = bdict["code"] as! Int
            if HttpManagement.HttpResponseCodeCheck(code, viewController: self){
                self.showAlertView(tag:1,title: "提示", message: "登录成功！", delegate: self, cancelButtonTitle: "确定")
            }else{
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
