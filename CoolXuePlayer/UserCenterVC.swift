//
//  UserCenterVC.swift
//  CoolXuePlayer
//
//  Created by lion-mac on 15/6/3.
//  Copyright (c) 2015年 lion-mac. All rights reserved.
//

import UIKit

class UserCenterVC: UIViewController,UITableViewDataSource,UITableViewDelegate {
    //是否请求过账号数据
    var is_getdata_flag:Bool = false
    var is_setHeadView:Bool = false
    var userInfo:User = User()
    lazy var headerView:UserInfoTabHeadV! = UserInfoTabHeadV.getUserInfoTabHeadV
    @IBOutlet weak var mTableView: UITableView!
    var items:Array<NSMutableDictionary> = [
        ["name":"我的积分","info":"","image":"menu_icon_5","turnToId":"","indicator":false],
        ["name":"我的爱酷币","info":"","image":"menu_icon_28","turnToId":"","indicator":false],
        //["name":"订阅","info":"","image":"menu_icon_5","turnToId":"ToReadListVC","indicator":true],
        ["name":"我的反馈","info":"","image":"menu_icon_3","turnToId":"ToFeedbackVC","indicator":true],
        //["name":"我的收藏","info":"","image":"menu_icon_3","turnToId":"ToFavoriteVC","indicator":true],
        ["name":"播放历史","info":"","image":"menu_icon_4","turnToId":"ToHistoryVC","indicator":true],
        
    ]
    var items2:Array<NSMutableDictionary> = [
        ["name":"帮助反馈","info":"","image":"menu_icon_7","turnToId":"ToFeedbackVC","indicator":true],
        ["name":"设置","info":"","image":"menu_icon_9","turnToId":"","indicator":true],
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
            self.headerView.userScoreLabel.text = ""
            //设置我的积分,我的爱酷币
            self.setInfo("",ingot: "")
        }else{
            self.headerView.userNameLabel.text = self.userInfo.nickName
            //self.headerView.userScoreLabel.text = "积分："+String(self.userInfo.score)
            self.headerView.bnUserHead.setBackgroundImage(UIImage(named:"loginHead"), forState: UIControlState.Normal)
            //设置我的积分,我的爱酷币
            self.setInfo(String(self.userInfo.score),ingot: String(self.userInfo.ingot))
        }
        if !self.is_setHeadView {
            self.is_setHeadView = true
            self.mTableView.beginUpdates()
            self.mTableView.tableHeaderView = self.headerView
            self.mTableView.endUpdates()
        }
        //有网络才请求数据
        if NetWorkHelper.is_network_ok == true {
            if !self.is_getdata_flag && LoginTool.isLogin == true {
                self.is_getdata_flag = true
                self.getUserInfo("http://www.icoolxue.com/account/my")
            }
        } else {
            println("Network Connection: Unavailable")
            D3Notice.showText("没有可用网络！",time:D3Notice.longTime,autoClear:true)
        }
    }
    
    //设置我的积分,我的爱酷币
    func setInfo(score:String,ingot:String){
        //设置我的积分
        var myscore = self.items[0]
        myscore.setValue(score, forKeyPath: "info")
        //设置我的爱酷币
        var myingot = self.items[1]
        myingot.setValue(ingot, forKey: "info")
    }
    
    func messageCallBack(){
        
    }
    
    //点击头像
    func headCallBack(){
        if LoginTool.isNeedUserLogin {
            self.performSegueWithIdentifier("VedioViewToLogin", sender: nil)
        }else{
            self.performSegueWithIdentifier("ToAccountInfoVC", sender: nil)
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
                self.headerView.userScoreLabel.text = ""
                //self.headerView.userScoreLabel.text = "积分："+String(self.userInfo.score)
                self.headerView.bnUserHead.setBackgroundImage(UIImage(named:"loginHead"), forState: UIControlState.Normal)
                //设置我的积分,我的爱酷币
                self.setInfo(String(self.userInfo.score),ingot: String(self.userInfo.ingot))
                self.mTableView.reloadData()
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
        cell?.infoLabel.text = data["info"]as? String
        cell?.nameLabel?.text = data["name"] as? String
        cell?.iconImageView?.image = UIImage(named: (data["image"] as? String)!)
        if data["indicator"] as? Bool == true {
            cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        }else{
            cell?.selectionStyle = UITableViewCellSelectionStyle.None //点击无效果
        }
        return cell!
    }
   
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        println("didDeselectRowAtIndexPath")
        var data:NSDictionary!
        if indexPath.section == 1 {
            data = self.items[indexPath.row]
        }else if indexPath.section == 2 {
            data = self.items2[indexPath.row]
        }
        var turnToId = data["turnToId"] as? String
        if turnToId!.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) > 0 {
            //订阅和反馈可以不登陆看列表
            if turnToId == "ToReadingList" || turnToId == "ToFeedbackList" {
                self.performSegueWithIdentifier(turnToId, sender: nil)
            }else{
                //需要登录,跳转到对应的登录提示界面
                if LoginTool.isNeedUserLogin {
                    var vc:UIViewController?
                    if turnToId == "ToHistoryVC" {
                        vc = HistoryUnLoginTipVC()
                        var s = UIStoryboard(name: "Main", bundle: nil)
                        var tab = s.instantiateViewControllerWithIdentifier("historyView") as? HistoryViewController
                        self.navigationController?.pushViewController(tab!, animated: false)
                    }else if turnToId == "ToFavoriteVC" {
                        vc = FavoriteUnLoginTipVC()
                        var s = UIStoryboard(name: "Main", bundle: nil)
                        var tab = s.instantiateViewControllerWithIdentifier("favoriteView") as? FavoriteVC
                        self.navigationController?.pushViewController(tab!, animated: false)
                    }else if turnToId == "ToFeedbackVC" {
                        vc = FeedbackUnLoginTipVC()
                        var s = UIStoryboard(name: "Main", bundle: nil)
                        var tab = s.instantiateViewControllerWithIdentifier("feedbackView") as? FeedbackVC
                        self.navigationController?.pushViewController(tab!, animated: false)
                    }
                    self.navigationController?.pushViewController(vc!, animated: true)
                }else{
                    self.performSegueWithIdentifier(turnToId, sender: nil)
                }
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
