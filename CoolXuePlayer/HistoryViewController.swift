//
//  HistoryViewController.swift
//  CoolXuePlayer
//
//  Created by lion-mac on 15/6/3.
//  Copyright (c) 2015年 lion-mac. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,LoadMoreFooterViewDelegate{
    func footerRefreshTableData(newChannel: Channel) {
        self.channelList.append(newChannel)
        self.productTableView.reloadData()
    }
    var currChannel:Channel?
    @IBOutlet weak var productTableView: UITableView!
    var channelList:Array<Channel> = []
    override func viewDidLoad() {
        super.viewDidLoad()
        println("viewDidLoad")
        self.productTableView.dataSource = self
        self.productTableView.delegate = self
        
        var footerView:LoadMoreFooterView = LoadMoreFooterView.loadMoreFooterView
        footerView.delegate = self
        self.productTableView.tableFooterView = footerView
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(animated: Bool) {
        println("viewWillAppear")
        var url = "http://www.icoolxue.com/video/log/my/1/10"
        getHistoryData(url)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getHistoryData(url:String){
        HttpManagement.requestttt(url, method: "GET",bodyParam: nil,headParam:nil) { (repsone:NSHTTPURLResponse,data:NSData) -> Void in
            var bdict:NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: nil) as!NSDictionary
            //println(bdict)
            var code:Int = bdict["code"] as! Int
            if HttpManagement.HttpResponseCodeCheck(code, viewController: self){
                var dict = bdict["data"] as! NSDictionary
                var c_array = dict["data"] as! NSArray
                if c_array.count > 0 {
                    for dict in c_array{
                        //println(dict["video"])
                        var channel = Channel(dictChannel: dict["video"] as! NSDictionary)
                        self.channelList.append(channel)
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
        return self.channelList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("channelCell", forIndexPath: indexPath) as! UITableViewCell
        var channel = self.channelList[indexPath.row]
        if channel.name == nil {
            return cell
        }
        cell.textLabel?.text = channel.name
        var imgurl:NSURL = NSURL(string: "")!
        if channel.defaultCover != nil {
            imgurl = NSURL(string:channel.defaultCover)!
        }else if channel.cover != nil {
            imgurl = NSURL(string:channel.cover)!
        }
        //println("imgurl=\(imgurl)")
        cell.imageView?.sd_setImageWithURL(imgurl, placeholderImage: UIImage(named: "def.png"), options: SDWebImageOptions.ContinueInBackground, progress: { (a:Int, b:Int) -> Void in
            //println("image pross=\(a/b)")
            }, completed: { (image:UIImage!, error:NSError!, cacheType:SDImageCacheType, imgurl:NSURL!) -> Void in
                //println("cached finished")
        })
        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.currChannel = self.channelList[indexPath.row]
        var channel_url = "http://www.icoolxue.com/video/play/url/"+String(self.currChannel!.id)
        getVedioPlayUrl(channel_url)
    }
    
    func getVedioPlayUrl(path:String){
        println("request url = \n\(path)")
        var headerParam:Dictionary<String,String> = ["referer":"http://www.icoolxue.com"]
        HttpManagement.requestttt(path, method: "GET",bodyParam: nil,headParam:headerParam) { (repsone:NSHTTPURLResponse,data:NSData) -> Void in
            var bdict:NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: nil) as!NSDictionary
            //println(bdict)
            var code:Int = bdict["code"] as! Int
            if HttpManagement.HttpResponseCodeCheck(code, viewController: self){
                var vedio_url = bdict["data"] as? String
                if vedio_url != nil {
                    self.currChannel?.vedioUrl = vedio_url
                    self.performSegueWithIdentifier("VedioPlaySegueId", sender: self.currChannel)
                }else{
                    println("Failed to Get Url!!!!!!!!")
                    var alert:UIAlertView = UIAlertView(title: "提示", message: "获取视频播放地址失败！", delegate: self, cancelButtonTitle: "确定")
                    alert.show()
                }
            }
        }
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if sender?.isKindOfClass(Channel) == true {
            var adController:VedioPlayerViewController = segue.destinationViewController as! VedioPlayerViewController
            adController.channel = sender as? Channel
        }
    }
}
