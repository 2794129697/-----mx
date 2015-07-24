//
//  AccountInfoVC.swift
//  CoolXuePlayer
//
//  Created by lion-mac on 15/7/14.
//  Copyright (c) 2015年 lion-mac. All rights reserved.
//

import UIKit

class AccountInfoVC: UIViewController,UITableViewDataSource,UITableViewDelegate {
    @IBOutlet weak var mTableView: UITableView!
    var items1:Array<NSMutableDictionary> = [
        ["name":"我的积分","info":"","image":"menu_icon_5","turnToId":"","indicator":false],
        
    ]
    var items2:Array<NSMutableDictionary> = []
    var items3:Array<NSMutableDictionary> = [
        ["name":"退出登录","info":"","image":"menu_icon_7","turnToId":"ToLoginOut","indicator":true],
    ]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mTableView.estimatedRowHeight = 100
        self.mTableView.rowHeight = UITableViewAutomaticDimension
        self.mTableView.dataSource = self
        self.mTableView.delegate = self
        self.mTableView.registerClass(UITableViewCell.classForCoder(),forCellReuseIdentifier: "AccountInfoTVCellID")
    }
    
    override func viewDidAppear(animated: Bool) {
    
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var number = 0
        if section == 0 {
            number = self.items1.count
        }else if section == 1 {
            number = self.items2.count
        }else if section == 2 {
            number = self.items3.count
        }
        return number
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var title = ""
        if section == 0 {
            title = "个人信息"
        }else if section == 1 {
            title = ""
        }else if section == 2 {
            title = "注销"
        }
        return title
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("AccountInfoTVCellID", forIndexPath: indexPath) as? UITableViewCell
        var data:NSDictionary!
        if indexPath.section == 0 {
            data = self.items1[indexPath.row]
        }else if indexPath.section == 1 {
            data = self.items2[indexPath.row]
        }else if indexPath.section == 2{
            data = self.items3[indexPath.row]
        }
        cell?.textLabel?.text = data["name"] as? String
        if data["indicator"] as? Bool == true {
            cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        }else{
            cell?.selectionStyle = UITableViewCellSelectionStyle.None //点击无效果
        }
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        var data:NSDictionary!
        if indexPath.section == 0 {
            data = self.items1[indexPath.row]
        }else if indexPath.section == 1 {
            data = self.items2[indexPath.row]
        }else if indexPath.section == 2 {
            data = self.items3[indexPath.row]
        }
        var turnToId = data["turnToId"] as? String
        if turnToId!.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) > 0 {
            //退出登录
            if turnToId == "ToLoginOut" {
                self.loginOut()
            }
        }
    }
    
    //用户登出
    func loginOut(){
        var url = "http://www.icoolxue.com/account/logout"
        HttpManagement.requestttt(url, method: "GET",bodyParam: nil,headParam:nil) { (repsone:NSHTTPURLResponse,data:NSData) -> Void in
            var bdict:NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: nil) as!NSDictionary
            //println(bdict)
            var code:Int = bdict["code"] as! Int
            var userAccount:NSUserDefaults = NSUserDefaults.standardUserDefaults()
            if HttpManagement.HttpResponseCodeCheck(code, viewController: self){
                userAccount.removeObjectForKey("uid")
                userAccount.removeObjectForKey("upwd")
                LoginTool.isLogin = false
                LoginTool.isNeedUserLogin = true
                self.navigationController?.popViewControllerAnimated(true)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
}
