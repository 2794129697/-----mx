//
//  subCategoryAlbumListViewController.swift
//  CoolXuePlayer
//
//  Created by lion-mac on 15/6/18.
//  Copyright (c) 2015年 lion-mac. All rights reserved.
//

import UIKit

class subCategoryAlbumListViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    var subCategory:CategorySub?
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
        var channel:Channel = self.channelList[indexPath.row]
        self.performSegueWithIdentifier("ListOfAlbumSegueId", sender: channel)
    }
    
    func getChannelData(){
        var url = "http://www.icoolxue.com/album/affix/\(self.subCategory!.value!)/1/10"
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
                        var channel = Channel(dictChannel: dict as! NSDictionary)
                        self.channelList.append(channel)
                    }
                    self.productTableView.reloadData()
                }
            }
        }
    }
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if sender?.isKindOfClass(Channel) == true {
            var adController:ListOfAlbumViewController = segue.destinationViewController as! ListOfAlbumViewController
            adController.channel = sender! as? Channel
        }
    }
}
