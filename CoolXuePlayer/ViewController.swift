//
//  ViewController.swift
//  CoolXuePlayer
//
//  Created by lion-mac on 15/5/29.

//

import UIKit

class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate {
    @IBOutlet weak var bigScrollView: UIScrollView!

    @IBOutlet weak var channelTableView: UITableView!
    @IBOutlet weak var topscrollview: UIScrollView!
    var channelList:Array<Channel> = []
    func getChannelData(){
        var channel_url = "http://www.icoolxue.com/album/recommend/100"
        var url = NSURL(string: channel_url)
        var request = NSURLRequest(URL: url!)
        NSURLConnection.sendAsynchronousRequest(
            request, queue: NSOperationQueue.mainQueue()) { (response:NSURLResponse!, data:NSData!, error:NSError!) -> Void in
                println("responseerror=\(error)")
                var httpResponse = response as! NSHTTPURLResponse
                if httpResponse.statusCode == 200 {
                    var bdict:NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: nil) as!NSDictionary
                    //println(bdict)
                    var c_array = bdict["data"] as! NSArray
                    if c_array.count > 0 {
                        for dict in c_array{
                            var channel = Channel(dictChannel: dict as! NSDictionary)
                            self.channelList.append(channel)
                            var uv = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
                            var imgview = UIImageView()
                            var imgurl:NSURL = NSURL(string: "")!
                            if channel.defaultCover != nil {
                                imgurl = NSURL(string:channel.defaultCover)!
                            }else if channel.cover != nil {
                                imgurl = NSURL(string:channel.cover)!
                            }
                            uv.addSubview(imgview)
                            imgview.sd_setImageWithURL(imgurl)
                            self.topscrollview.addSubview(uv)
                            //self.topscrollview.insertSubview(uv, atIndex: 0)
                        }
                        self.topscrollview.contentSize = CGSize(width: 2000, height: 100)
                        self.channelTableView.reloadData()
                        
                    }
                }
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView.isKindOfClass(UITableView){
            println("tableview move")
            channelTableView.scrollEnabled = false;
        }else{
            println("scrollview move")
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getChannelData()
        self.bigScrollView.contentSize=CGSizeMake(320, 1264);
        // Do any additional setup after loading the view, typically from a nib.
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        println("numberOfRowsInSection=\(section)")
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
        println("imgurl=\(imgurl)")
        cell.imageView?.sd_setImageWithURL(imgurl, placeholderImage: UIImage(named: "default_hoder_170x100.jpg"), options: SDWebImageOptions.ContinueInBackground, progress: { (a:Int, b:Int) -> Void in
            println("image pross=\(a/b)")
            }, completed: { (image:UIImage!, error:NSError!, cacheType:SDImageCacheType, imgurl:NSURL!) -> Void in
                println("cached finished")
        })
        return cell
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

