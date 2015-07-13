//
//  UserInfoViewController.swift
//  CoolXuePlayer
//
//  Created by lion-mac on 15/6/3.
//  Copyright (c) 2015年 lion-mac. All rights reserved.
//

import UIKit

class UserInfoViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    var userInfo:User = User()
    lazy var headerView:UserInfoTabHeadV! = UserInfoTabHeadV.getUserInfoTabHeadV
    @IBOutlet weak var mTableView: UITableView!
    var items:Array<NSDictionary> = [
        ["name":"订阅","info":"共0个","image":"menu_icon_5","turnToId":""],
        ["name":"我的收藏","info":"共0个","image":"menu_icon_3","turnToId":""],
        ["name":"播放历史","info":"共0个","image":"menu_icon_4","turnToId":"ToHistoryVC"],
        ["name":"我的爱酷币","info":"系统设置","image":"menu_icon_28","turnToId":""]
    ]
    var items2:Array<NSDictionary> = [
        ["name":"帮助反馈","info":"共0个","image":"menu_icon_7","turnToId":""],
        ["name":"设置","info":"共0个","image":"menu_icon_9","turnToId":""],
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.mTableView.estimatedRowHeight = 100
        self.mTableView.rowHeight = UITableViewAutomaticDimension
        self.mTableView.dataSource = self
        self.mTableView.delegate = self
        var nib = UINib(nibName: "UserInfoTVCell", bundle: nil)
        self.mTableView.registerNib(nib, forCellReuseIdentifier: "UserInfoTVCellID")
        self.headerView.messageCallBack = self.messageCallBack
        self.headerView.headCallBack = self.headCallBack
//        self.view.layer.masksToBounds = false
//        self.view.layer.cornerRadius = 8;
//        self.view.layer.shadowOffset = CGSizeMake(-5, 5);
//        self.view.layer.shadowRadius = 5;
//        self.view.layer.shadowOpacity = 0.5;
//        
//        self.mTableView.layer.cornerRadius = 5;
//        //self.mTableView.backgroundColor = UIColor(red: 0.239, green: 0.239, blue: 0.239, alpha: 1)
//        self.mTableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
//        self.mTableView.separatorColor = UIColor.grayColor()
//        //self.mTableView.separatorStyle = UITableViewCellSeparatorStyle.None
    }
    
    override func viewDidAppear(animated: Bool) {
        if LoginTool.isNeedUserLogin {
            self.headerView.userNameLabel.text = "点击登录"
        }else{
            self.headerView.userNameLabel.text = self.userInfo.nickName
            self.headerView.userScoreLabel.text = "积分："+String(self.userInfo.score)
            self.headerView.bnUserHead.setBackgroundImage(UIImage(named:"loginHead"), forState: UIControlState.Normal)
        }
        self.mTableView.tableHeaderView = self.headerView
        if LoginTool.isLogin == true {
            self.getUserInfo("http://www.icoolxue.com/account/my")
        }
    }
    
    func messageCallBack(){
        
    }
    func headCallBack(){
        if LoginTool.isNeedUserLogin {
           self.performSegueWithIdentifier("VedioViewToLogin", sender: nil)
        }
    }
    func getUserInfo(url:String){
        HttpManagement.requestttt(url, method: "GET",bodyParam: nil,headParam:nil) { (repsone:NSHTTPURLResponse,data:NSData) -> Void in
            var bdict:NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: nil) as!NSDictionary
            //println(bdict)
            var code:Int = bdict["code"] as! Int
            if HttpManagement.HttpResponseCodeCheck(code, viewController: self){
                var dict = bdict["data"] as! NSDictionary
                self.userInfo = User(dictUser: dict)
                self.headerView.userNameLabel.text = self.userInfo.nickName
                self.headerView.userScoreLabel.text = "积分："+String(self.userInfo.score)
                self.headerView.bnUserHead.setBackgroundImage(UIImage(named:"loginHead"), forState: UIControlState.Normal)
               println(dict)
            }
        }
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var number = 0
        if section == 0 {
            number = 0
        }else if section == 1 {
            number = self.items.count
        }else if section == 2 {
            number = self.items2.count
        }
        return number
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 4
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("UserInfoTVCellID", forIndexPath: indexPath) as? UserInfoTVCell
        var data:NSDictionary!
        if indexPath.section == 1 {
            data = self.items[indexPath.row]
        }else if indexPath.section == 2{
            data = self.items2[indexPath.row]
        }
        cell?.nameLabel?.text = data["name"] as? String
        cell?.iconImageView?.image = UIImage(named: (data["image"] as? String)!)
        cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        return cell!
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        println("didDeselectRowAtIndexPath")
        if indexPath.section == 1 {
            var data = self.items[indexPath.row]
            var turnToId = data["turnToId"] as? String
            if turnToId!.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) > 0 {
                self.performSegueWithIdentifier(turnToId, sender: nil)
            }
        }else if indexPath.section == 2 {
            var data = self.items2[indexPath.row]
            var turnToId = data["turnToId"] as? String
            if turnToId!.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) > 0 {
                self.performSegueWithIdentifier(turnToId, sender: nil)
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
