//
//  FeedbackVC.swift
//  CoolXuePlayer
//
//  Created by lion-mac on 15/7/23.
//  Copyright (c) 2015年 lion-mac. All rights reserved.
//

import UIKit

class FeedbackVC: UIViewController,UITableViewDelegate,UITableViewDataSource{
    @IBOutlet weak var productTableView: UITableView!
    var feedbackList:Array<FeedbackModel> = []
    var feedback_url = "http://www.icoolxue.com/feedback/my/1/50"
    override func viewDidLoad() {
        super.viewDidLoad()
        var nib = UINib(nibName: "FeedbackTabVCell", bundle: nil)
        self.productTableView.registerNib(nib, forCellReuseIdentifier: "FeedbackTabVCellID")
        
        // 经过测试，实际表现及运行效率均相似，大👍
        self.productTableView.estimatedRowHeight = 100
        self.productTableView.rowHeight = UITableViewAutomaticDimension
        
        self.productTableView.dataSource = self
        self.productTableView.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        if LoginTool.isLogin == true {
            self.getFeedbackList(self.feedback_url)
        }
    }
    
    func getFeedbackList(url:String){
        HttpManagement.requestttt(url, method: "GET",bodyParam: nil,headParam:nil) { (repsone:NSHTTPURLResponse,data:NSData) -> Void in
            var bdict:NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: nil) as!NSDictionary
            //println(bdict)
            var code:Int = bdict["code"] as! Int
            if HttpManagement.HttpResponseCodeCheck(code, viewController: self){
                self.feedbackList.removeAll(keepCapacity: true)
                var dict = bdict["data"] as! NSDictionary
                var c_array = dict["data"] as! NSArray
                if c_array.count > 0 {
                    for dict in c_array{
                        var feedbackModel = FeedbackModel(dict:dict as! NSDictionary)
                        self.feedbackList.append(feedbackModel)
                    }
                    self.productTableView.reloadData()
                }
            }
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.feedbackList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("FeedbackTabVCellID", forIndexPath: indexPath) as? FeedbackTabVCell
        var feedbackModel = self.feedbackList[indexPath.row]
        cell?.textLabel?.text = feedbackModel.content
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        var feedbackModel = self.feedbackList[indexPath.row]
        self.performSegueWithIdentifier("ToVedioListVC", sender: feedbackModel)
    }

    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
