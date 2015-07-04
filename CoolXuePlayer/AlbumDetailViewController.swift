//
//  AlbumDetailViewController.swift
//  CoolXuePlayer
//
//  Created by lion-mac on 15/6/3.
//  Copyright (c) 2015年 lion-mac. All rights reserved.
//

import UIKit

class AlbumDetailViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    var channel:Channel?

    @IBOutlet weak var productTableView: UITableView!
    
    var channelList:Array<Channel> = []
    override func viewDidLoad() {
        super.viewDidLoad()
        var nib = UINib(nibName: "VedioListTabVCell", bundle: nil)
        self.productTableView.registerNib(nib, forCellReuseIdentifier: "VedioListTabVCellID")
        
        // 经过测试，实际表现及运行效率均相似，大👍
        self.productTableView.estimatedRowHeight = 100
        self.productTableView.rowHeight = UITableViewAutomaticDimension
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
        var cell = tableView.dequeueReusableCellWithIdentifier("VedioListTabVCellID", forIndexPath: indexPath) as? VedioListTabVCell
        var vedio = self.channelList[indexPath.row] as Channel
        cell!.nameLabel.text = vedio.name
        cell!.authorLabel.text = "作者："+vedio.author
        cell!.palyTimesLabel.text = "播放次数：7878"
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
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("xxxxxxListOfAlbumSegueId")
        var channel:Channel = self.channelList[indexPath.row]
        self.performSegueWithIdentifier("ListOfAlbumSegueId", sender: channel)
        //self.navigationController?.pushViewController(LoginUITabBarController(), animated: false)
        //self.navigationController?.tabBarController = LoginUITabBarController()
    }
    
    func getChannelData(){
        var url = "http://www.icoolxue.com/album/related/"+(self.channel!.affix)+"/10"
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
//        var channel_url = "http://www.icoolxue.com/album/related/"+(self.channel!.affix)+"/10"
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
            var adController:ListOfAlbumViewController = segue.destinationViewController as! ListOfAlbumViewController
            adController.channel = sender! as? Channel
        }
    }

}
