//
//  ToVedioListVC.swift
//  CoolXuePlayer
//
//  Created by lion-mac on 15/6/3.
//  Copyright (c) 2015年 lion-mac. All rights reserved.
//

import UIKit

class VedioListVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var channel:Vedio?
    var currVedio:Vedio?
    @IBOutlet weak var productTableView: UITableView!
    var channelList:Array<Vedio> = []
    override func viewDidLoad() {
        super.viewDidLoad()
        var nib = UINib(nibName: "VedioListTabVCell", bundle: nil)
        self.productTableView.registerNib(nib, forCellReuseIdentifier: "VedioListTabVCellID")
        
        // 经过测试，实际表现及运行效率均相似，大👍
        self.productTableView.estimatedRowHeight = 100
        self.productTableView.rowHeight = UITableViewAutomaticDimension

        self.productTableView.delegate = self
        self.productTableView.dataSource = self
        self.getVedioListData()
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
        var cell = tableView.dequeueReusableCellWithIdentifier("VedioListTabVCellID", forIndexPath: indexPath) as? VedioListTabVCell
        var vedio = self.channelList[indexPath.row] as Vedio
        cell!.nameLabel.text = vedio.name
        cell!.authorLabel.text = "作者："+vedio.author
        cell!.palyTimesLabel.text = "播放次数：\(vedio.playTimes)"
        cell!.playCostLabel.text = "爱苦逼：\(vedio.playCost)"
        var imgurl:NSURL = NSURL(string: "")!
        if vedio.defaultCover.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) != 0 {
            imgurl = NSURL(string:vedio.defaultCover)!
        }else if vedio.cover.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) != 0 {
            imgurl = NSURL(string:vedio.cover)!
        }
        //println("imgurl=\(imgurl)")
        cell!.vedioImage.sd_setImageWithURL(imgurl, placeholderImage: UIImage(named: "defx.png"), options: SDWebImageOptions.ContinueInBackground, progress: { (a:Int, b:Int) -> Void in
            //println("image pross=\(a/b)")
            }, completed: { (image:UIImage!, error:NSError!, cacheType:SDImageCacheType, imgurl:NSURL!) -> Void in
                //println("cached finished")
        })
        return cell!
    }

    func getVedioListData(){
        var url = "http://www.icoolxue.com/album/video/list/"+String(self.channel!.id)
        HttpManagement.requestttt(url, method: "GET",bodyParam: nil,headParam:nil) { (repsone:NSHTTPURLResponse,data:NSData) -> Void in
            var bdict:NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: nil) as!NSDictionary
           // println(bdict)
            var code:Int = bdict["code"] as! Int
            if HttpManagement.HttpResponseCodeCheck(code, viewController: self){
                var c_array = bdict["data"] as! NSArray
                if c_array.count > 0 {
                    for dict in c_array{
                        var vedio = Vedio(dictVedio: dict as! NSDictionary)
                        vedio.createTime = self.channel?.createTime
                        vedio.affix = self.channel?.affix
                        self.channelList.append(vedio)
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
//                            var channel = Vedio(dictVedio: dict as! NSDictionary)
//                            self.channelList.append(channel)
//                        }
//                        self.productTableView.reloadData()
//                    }
//                }
//        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.currVedio = self.channelList[indexPath.row]
        //self.performSegueWithIdentifier("VedioPlaySegueId", sender: self.currVedio)
        var channel_url = "http://www.icoolxue.com/video/play/url/"+String(self.currVedio!.id)
        getVedioPlayUrl(channel_url)
    }
    
    func getVedioPlayUrl(path:String){
        //println("request url = \(path)")
        var headerParam:Dictionary<String,String> = ["referer":"http://www.icoolxue.com"]
        HttpManagement.requestttt(path, method: "GET",bodyParam: nil,headParam:headerParam) { (repsone:NSHTTPURLResponse,data:NSData) -> Void in
            var bdict:NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: nil) as!NSDictionary
            //println(bdict)
            var code:Int = bdict["code"] as! Int
            if HttpManagement.HttpResponseCodeCheck(code, viewController: self){
                var vedio_url = bdict["data"] as? String
                if vedio_url != nil {
                    self.currVedio?.vedioUrl = vedio_url
                    self.performSegueWithIdentifier("VedioPlaySegueId", sender: self.currVedio)
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
        //                            self.currVedio?.vedioUrl = vedio_url
        //                            self.performSegueWithIdentifier("VedioPlaySegueId", sender: self.currVedio)
        //                        }else{
        //                            println("Failed to Get Url!!!!!!!!")
        //                            var alert:UIAlertView = UIAlertView(title: "提示", message: "获取视频播放地址失败！", delegate: self, cancelButtonTitle: "确定")
        //                            alert.show()
        //                        }
        //                    }
        //                }
        //        }
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "VedioPlaySegueId" {
            if sender?.isKindOfClass(Vedio) == true {
                var adController:VedioPlayerViewController = segue.destinationViewController as! VedioPlayerViewController
                adController.channel = sender! as? Vedio
            }
        }
    }
}
