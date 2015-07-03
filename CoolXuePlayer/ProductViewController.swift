//
//  ProductViewController.swift
//  CoolXuePlayer
//
//  Created by lion-mac on 15/6/1.
//  Copyright (c) 2015年 lion-mac. All rights reserved.
//

import UIKit

class ProductViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,
    LoadMoreFooterViewDelegate,ProductHeadViewDelegate {
    
    func productHeadViewShowItem(channel: Channel) {
        self.performSegueWithIdentifier("AlbumDetailSegueId", sender: channel)
    }
    func footerRefreshTableData(newChannel: Channel) {
        self.channelList.append(newChannel)
        self.productTableView.reloadData()
    }
    func historyViewShowItem(channel: Array<Channel>!) {
        self.performSegueWithIdentifier("HistorySugueId", sender: channel)
        //self.navigationController?.pushViewController(HistoryViewController(), animated: true)
    }
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var productTableView: UITableView!
    var channelList:Array<Channel> = []
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationController?.navigationBar.barTintColor = UIColor.blackColor()
        //self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        //self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "searchresult_bg.png"), forBarMetrics: UIBarMetrics.Default)

//        self.navigationController?.navigationBar.setBackgroundImage(NSString.imageWithColor(UIColor.clearColor(),andSize:CGSize(width: self.view.frame.width, height: 64)), forBarMetrics: UIBarMetrics.Default)
        
//        var muinib:UINib = UINib(nibName: "ProductTableCell", bundle:nil)
//        self.productTableView.registerNib(muinib, forCellReuseIdentifier: "ProductCellID")
        self.productTableView.delegate = self
        self.productTableView.dataSource = self
        //self.navItem.title = "视频"
        
//        var headView:ProductHeadView = ProductHeadView.productHeadView
//        headView.delegate = self
//        self.productTableView.tableHeaderView = headView
        (self.productTableView.tableHeaderView as! ProductHeadView).delegate = self
        
        var footerView:LoadMoreFooterView = LoadMoreFooterView.loadMoreFooterView
        footerView.delegate = self
        self.productTableView.tableFooterView = footerView
        
        self.getChannelData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.channelList.count
    }
//    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        return 94
//    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        var cell:UITableViewCell! = tableView.dequeueReusableCellWithIdentifier("ProductCellID", forIndexPath: indexPath) as! UITableViewCell
//        if (cell == nil) {
//            cell = ProductTabCellView.GetProductTabCellView
//        }
//        return cell
        var cell:ProductTabCellView = tableView.dequeueReusableCellWithIdentifier("ProductCellID", forIndexPath: indexPath) as! ProductTabCellView
        var channel = self.channelList[indexPath.row]
        if channel.name == nil {
            return cell
        }
        cell.authorLabel.text = channel.author
        cell.nameLabel?.text = channel.name
        var imgurl:NSURL = NSURL(string: "")!
        if channel.defaultCover != nil {
            imgurl = NSURL(string:channel.defaultCover)!
        }else if channel.cover != nil {
            imgurl = NSURL(string:channel.cover)!
        }
        //println("imgurl=\(imgurl)")
        cell.pImage?.sd_setImageWithURL(imgurl, placeholderImage: UIImage(named: "defx.png"), options: SDWebImageOptions.ContinueInBackground, progress: { (a:Int, b:Int) -> Void in
            //println("image pross=\(a/b)")
            }, completed: { (image:UIImage!, error:NSError!, cacheType:SDImageCacheType, imgurl:NSURL!) -> Void in
                //println("cached finished")
        })
        return cell

        /*
        var cell = tableView.dequeueReusableCellWithIdentifier("ProductCellID", forIndexPath: indexPath) as! UITableViewCell
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
        cell.imageView?.sd_setImageWithURL(imgurl, placeholderImage: UIImage(named: "defx.png"), options: SDWebImageOptions.ContinueInBackground, progress: { (a:Int, b:Int) -> Void in
            //println("image pross=\(a/b)")
            }, completed: { (image:UIImage!, error:NSError!, cacheType:SDImageCacheType, imgurl:NSURL!) -> Void in
                //println("cached finished")
        })
        return cell
        */
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //println("ssss")
        var channel:Channel = self.channelList[indexPath.row]
        //performSegueWithIdentifier(identifier: String?, sender: AnyObject?)
        self.performSegueWithIdentifier("AlbumDetailSegueId", sender: channel)
    }
    
    func getChannelData(){
//        var url = "http://www.icoolxue.com/album/recommend/10"
//        HttpManagement.httpTask.GET(url, parameters: nil) { (response:HTTPResponse) -> Void in
//            var data = response.responseObject as! NSData
//            if response.statusCode == 200 {
//                var bdict:NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: nil) as!NSDictionary
//                //println(bdict)
//                var c_array = bdict["data"] as! NSArray
//                if c_array.count > 0 {
//                    for dict in c_array{
//                        var channel = Channel(dictChannel: dict as! NSDictionary)
//                        self.channelList.append(channel)
//                    }
//                    self.productTableView.reloadData()
//                }
//
//            }
//        }
        var url = "http://www.icoolxue.com/album/recommend/10"
        HttpManagement.requestttt(url, method: "GET",bodyParam: nil,headParam:nil) { (repsone:NSHTTPURLResponse,data:NSData) -> Void in
            var bdict:NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: nil) as!NSDictionary
            //println(bdict)
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
        
//        var channel_url = "http://www.icoolxue.com/album/recommend/10"
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


    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if sender?.isKindOfClass(Channel) == true {
            var adController:AlbumDetailViewController = segue.destinationViewController as! AlbumDetailViewController
            adController.channel = sender as? Channel
        }
    }
}
