//
//  RegisterViewController.swift
//  CoolXuePlayer
//
//  Created by lion-mac on 15/6/4.
//  Copyright (c) 2015年 lion-mac. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController,UITextFieldDelegate,UIAlertViewDelegate{
    @IBOutlet weak var userIdTextField: UITextField!
    @IBOutlet weak var pwdTextField: UITextField!
    @IBOutlet weak var pwdAgainTextField: UITextField!
    @IBOutlet weak var jobTextField: UITextField!
    @IBOutlet weak var bnSelectJop: UIButton!
    var alertView:UIAlertView!
    var popView:uiPopView!
    var job:Int!
    //实现job选择后的回调函数
    func selectionHandler(selectedItem:NSDictionary){
        self.popView = nil
        jobTextField.text = selectedItem["name"] as! String
        self.job =  selectedItem["id"] as! Int
    }
    //展开职业选项
    @IBAction func bnSelectJobClicked(sender: UIButton) {
        let btn = sender
        if self.popView == nil {
            self.popView = uiPopView(selectedItemCallBack: self.selectionHandler)
            self.popView.showDropDown(sender.superview!, frame: sender.frame, bounds: sender.bounds)
        }else{
            self.popView.hideDropDown()
            self.popView = nil
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
        self.registerBnClicked("")
        self.userIdTextField.resignFirstResponder()
        self.pwdTextField.resignFirstResponder()
        self.pwdAgainTextField.resignFirstResponder()
        return true
    }
    
    @IBAction func registerBnClicked(sender: AnyObject) {
        var userid = self.userIdTextField.text
        var pwd = self.pwdTextField.text
        var pwdAgain = self.pwdAgainTextField.text
        if userid.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) <= 0 {
            self.showAlertView(tag: 0,title: "提示", message: "用户名不能为空！", delegate: self, cancelButtonTitle: "确定")
            return
        }
        if self.job == nil {
            self.showAlertView(tag: 0,title: "提示", message: "请选择职业！", delegate: self, cancelButtonTitle: "确定")
            return
        }

        if pwd.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) <= 0 {
            self.showAlertView(tag: 0,title: "提示", message: "密码不能为空！", delegate: self, cancelButtonTitle: "确定")
            return
        }
        if pwdAgain.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) <= 0 {
            self.showAlertView(tag: 0,title: "提示", message: "确认密码不能为空！", delegate: self, cancelButtonTitle: "确定")
            return
        }
        if pwd != pwdAgain {
            self.showAlertView(tag: 0,title: "提示", message: "两次密码输入不一致！", delegate: self, cancelButtonTitle: "确定")
            return
        }
        var url = "http://www.icoolxue.com/account/register"
        var bodyParam:NSDictionary = ["username":userid,"job":self.job!,"password":pwd,"passwordAgain":pwdAgain]
        HttpManagement.requestttt(url, method: "POST",bodyParam: bodyParam as! Dictionary<String, AnyObject>,headParam:nil) { (repsone:NSHTTPURLResponse,data:NSData) -> Void in
            var bdict:NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: nil) as!NSDictionary
            println(bdict)
            var code:Int = bdict["code"] as! Int
            if HttpManagement.HttpResponseCodeCheck(code, viewController: self){
                self.showAlertView(tag: 1,title: "提示", message: "注册成功！", delegate: self, cancelButtonTitle: "确定")
            }else{
                self.showAlertView(tag: 0,title: "提示", message: "注册失败！", delegate: self, cancelButtonTitle: "确定")
            }
        }
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        println("buttonIndex=\(buttonIndex)")
        if alertView.tag == 0 {
            
        }else if alertView.tag == 1 {
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.userIdTextField.delegate = self
        self.pwdTextField.delegate = self
        self.pwdAgainTextField.delegate = self
        // Do any additional setup after loading the view.
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
