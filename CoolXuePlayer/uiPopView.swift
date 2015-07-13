//
//  uiPopView.swift
//  CoolXuePlayer
//
//  Created by lion-mac on 15/7/12.
//  Copyright (c) 2015年 lion-mac. All rights reserved.
//

import UIKit

class uiPopView: UIView,UITableViewDelegate,UITableViewDataSource{
    convenience init(selectedItemCallBack:(selectedItem:NSDictionary)->Void){
        self.init()
        self.selecttionHandler = selectedItemCallBack
    }

    lazy var items:Array<NSDictionary> = [
        ["id":1,"name":"页面重构设计"],
        ["id":2,"name":"交互设计师"],
        ["id":3,"name":"产品经理"],
        ["id":4,"name":"UI设计师"],
        ["id":5,"name":"Javascript工程师"],
        ["id":6,"name":"Web前端工程师"],
        ["id":7,"name":"移动开发工程师"],
        ["id":8,"name":"PHP开发工程师"],
        ["id":9,"name":"软件测试工程师"],
        ["id":10,"name":"Linux系统工程师"],
        ["id":11,"name":"Java开发工程师"],
        ["id":12,"name":"学生"],
        ["id":100,"name":"其他"],
    ]
    var cancelBarButtonItem:UIBarButtonItem!
    lazy var popTable:UITableView = UITableView()
    //选择职业后的回调函数
    var selecttionHandler:((selectedItem:NSDictionary)->Void)?
    func showDropDown(superView:UIView,frame:CGRect,bounds:CGRect)->UIView{
        self.layer.anchorPoint = CGPointMake(0, 0)
        self.frame = CGRectMake(frame.origin.x, frame.origin.y+bounds.size.height, bounds.size.width, 0);
        
        self.backgroundColor = UIColor.greenColor()
        
        self.layer.masksToBounds = false
        self.layer.cornerRadius = 8;
        self.layer.shadowOffset = CGSizeMake(-5, 5);
        self.layer.shadowRadius = 5;
        self.layer.shadowOpacity = 0.5;
        
        //var self.popTable = UITableView()
        self.popTable.layer.anchorPoint = CGPointMake(0, 0)
        self.popTable.frame = CGRectMake(0, 0, bounds.size.width, 0)
        self.popTable.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: "Cell")

        self.popTable.delegate = self
        self.popTable.dataSource = self
        self.popTable.layer.cornerRadius = 5;
        //self.popTable.backgroundColor = UIColor(red: 0.239, green: 0.239, blue: 0.239, alpha: 1)
        self.popTable.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        self.popTable.separatorColor = UIColor.grayColor()
        
        //            UIView.beginAnimations(nil, context: nil)
        //            UIView.setAnimationDuration(0.5)
        //            self.frame = CGRectMake(frame.origin.x, frame.origin.y+bounds.size.height, bounds.size.width, 200);
        //            self.popTable.frame = CGRectMake(0, 0, bounds.size.width, 200);
        //            UIView.commitAnimations()
        //            self.view.addSubview(self)
        //            self.addSubview(self.popTable)
        
        superView.addSubview(self)
        self.addSubview(self.popTable)
        
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            self.bounds = CGRectMake(0,0, bounds.size.width, 260)
            self.popTable.bounds = CGRectMake(0, 0, bounds.size.width, 260);
            }, completion: { (Bool) -> Void in
        })
        return self
    }
    
    func hideDropDown(){
        //            UIView.beginAnimations(nil, context: nil)
        //            UIView.setAnimationDuration(0.5)
        //            self.popView.frame = CGRectMake(btn.frame.origin.x, btn.frame.origin.y+btn.bounds.size.height, btn.bounds.size.width, 0);
        //            self.jobTable.frame = CGRectMake(0, 0, btn.bounds.size.width, 0);
        //            UIView.commitAnimations()
        UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            self.bounds = CGRectMake(0,0, self.bounds.size.width, 0)
            self.popTable.bounds = CGRectMake(0, 0, self.popTable.bounds.size.width, 0);
            }, completion: { (Bool) -> Void in
                self.popTable.removeFromSuperview()
                self.removeFromSuperview()
        })
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 30
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
        cell.textLabel?.text = self.items[indexPath.row]["name"] as? String
        cell.textLabel?.font = UIFont.systemFontOfSize(14)
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectItem = self.items[indexPath.row] as NSDictionary
        self.selecttionHandler!(selectedItem: selectItem)
        self.hideDropDown()
    }
    // MARK: - Table view data source

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
}
