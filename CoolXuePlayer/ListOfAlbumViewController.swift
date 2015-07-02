//
//  ListOfAlbumViewController.swift
//  CoolXuePlayer
//
//  Created by lion-mac on 15/6/3.
//  Copyright (c) 2015年 lion-mac. All rights reserved.
//

import UIKit

class ListOfAlbumViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var channel:Channel?
    var currChannel:Channel?
    @IBOutlet weak var productTableView: UITableView!
    var channelList:Array<Channel> = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.productTableView.delegate = self
        self.productTableView.dataSource = self
        self.getChannelData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 0
        }else {
            return self.channelList.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("CellId", forIndexPath: indexPath) as! UITableViewCell
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
        //println("xxxxxx222")
        self.currChannel = self.channelList[indexPath.row]
        //performSegueWithIdentifier(identifier: String?, sender: AnyObject?)
        //self.performSegueWithIdentifier("VedioPlaySegueId", sender: self.currChannel)
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
        
//        var url = NSURL(string: path)
//        var request = NSMutableURLRequest (URL: url!)
//        request.setValue("www.icoolxue.com", forHTTPHeaderField: "referer")
//        NSURLConnection.sendAsynchronousRequest(
//            request, queue: NSOperationQueue.mainQueue()) { (response:NSURLResponse!, data:NSData!, error:NSError!) -> Void in
//                //println("responseerror=\(error)")
//                var httpResponse = response as! NSHTTPURLResponse
//                var str = NSString(data: data, encoding:NSUTF8StringEncoding)
//                println("str =\(str)")
//                println()
//                if httpResponse.statusCode == 200 {
//                    var bdict:NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: nil) as!NSDictionary
//                    var code:Int = bdict["code"] as! Int
//                    if HttpManagement.HttpResponseCodeCheck(code, viewController: self){
//                        var vedio_url = bdict["data"] as? String
//                        if vedio_url != nil {
//                            self.currChannel?.vedioUrl = vedio_url
//                            self.performSegueWithIdentifier("VedioPlaySegueId", sender: self.currChannel)
//                        }else{
//                            println("Failed to Get Url!!!!!!!!")
//                            var alert:UIAlertView = UIAlertView(title: "提示", message: "获取视频播放地址失败！", delegate: self, cancelButtonTitle: "确定")
//                            alert.show()
//                        }
//                    }
//                }
//        }
    }
    
    func getChannelData(){
        var url = "http://www.icoolxue.com/album/video/list/"+String(self.channel!.id)
        HttpManagement.requestttt(url, method: "GET",bodyParam: nil,headParam:nil) { (repsone:NSHTTPURLResponse,data:NSData) -> Void in
            var bdict:NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: nil) as!NSDictionary
           // println(bdict)
            var code:Int = bdict["code"] as! Int
            if HttpManagement.HttpResponseCodeCheck(code, viewController: self){
                var c_array = bdict["data"] as! NSArray
                if c_array.count > 0 {
                    for dict in c_array{
                        var channel = Channel(dictChannel: dict as! NSDictionary)
                        self.channelList.append(channel)
                    }
                    self.productTableView.reloadData()
                }
            }
        }
        
        
//        var channel_url = "http://www.icoolxue.com/album/video/list/"+String(self.channel!.id)
//        var url = NSURL(string: channel_url)
//        var request = NSURLRequest(URL: url!)
//        NSURLConnection.sendAsynchronousRequest(
//            request, queue: NSOperationQueue.mainQueue()) { (response:NSURLResponse!, data:NSData!, error:NSError!) -> Void in
//                println("responseerror=\(error)")
//                var httpResponse = response as! NSHTTPURLResponse
//                if httpResponse.statusCode == 200 {
//                    var bdict:NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: nil) as!NSDictionary
//                    //println(bdict)
//                    var c_array = bdict["data"] as! NSArray
//                    if c_array.count > 0 {
//                        for dict in c_array{
//                            var channel = Channel(dictChannel: dict as! NSDictionary)
//                            self.channelList.append(channel)
//                        }
//                        self.productTableView.reloadData()
//                    }
//                }
//        }
    }
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if sender?.isKindOfClass(Channel) == true {
            var adController:VedioPlayerViewController = segue.destinationViewController as! VedioPlayerViewController
            adController.channel = sender! as? Channel
        }
    }
}
