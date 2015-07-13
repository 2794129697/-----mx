//
//  ProductViewController.swift
//  CoolXuePlayer
//
//  Created by lion-mac on 15/6/1.
//  Copyright (c) 2015年 lion-mac. All rights reserved.
//

import UIKit

class ProductViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,
    LoadMoreFooterViewDelegate,ProductHeadViewDelegate{
    var userDefault:NSUserDefaults = NSUserDefaults.standardUserDefaults()
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var productTableView: UITableView!
    var relatedAlbumList:Array<Vedio> = []
    var newAlbumList:Array<Vedio> = []
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
        
//        var footerView:LoadMoreFooterView = LoadMoreFooterView.loadMoreFooterView
//        footerView.delegate = self
//        self.productTableView.tableFooterView = footerView
        (self.productTableView.tableFooterView as! LoadMoreFooterView).delegate = self
        var nib = UINib(nibName: "IndexTVCell", bundle: nil)
        self.productTableView.registerNib(nib, forCellReuseIdentifier: "IndexTVCellID")
        
        // 经过测试，实际表现及运行效率均相似，大👍
        self.productTableView.estimatedRowHeight = 100
        self.productTableView.rowHeight = UITableViewAutomaticDimension
        
        self.productTableView.delegate = self
        self.productTableView.dataSource = self

        var relatedAlbumList:Array<Vedio>! = self.loadListLocal("IndexRelatedAlbumList")
        if relatedAlbumList != nil && relatedAlbumList.count > 0 {
            self.relatedAlbumList = relatedAlbumList
        }
        var newAlbumList:Array<Vedio>! = self.loadListLocal("IndexNewAlbumList")
        if newAlbumList != nil && newAlbumList.count > 0 {
            self.newAlbumList = newAlbumList
        }
        if self.relatedAlbumList.count > 0 || self.newAlbumList.count > 0 {
            self.productTableView.reloadData()
        }
        if IJReachability.isConnectedToNetwork() {
            println("Network Connection: Available")
            LoginTool.autoLogin()
            //推荐
            self.getRelatedAlbumData()
            //最新
            self.getNewAlbumData()
        } else {
            println("Network Connection: Unavailable")
            showNoticeText("网络不给力请重试！")
        }
        let statusType = IJReachability.isConnectedToNetworkOfType()
        switch statusType {
        case .WWAN:
            println("Connection Type: Mobile\n")
        case .WiFi:
            println("Connection Type: WiFi\n")
        case .NotConnected:
            println("Connection Type: Not connected to the Internet\n")
        }
        println("LoginTool.isLogin=\(LoginTool.isLogin)\n")
        self.checkNetWork()
    }
    var hostReachability:Reachability!
    var internetReachability:Reachability!
    var wifiReachability:Reachability!
    func checkNetWork(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reachabilityChanged:", name: kReachabilityChangedNotification, object: nil)
        
        self.hostReachability = Reachability(hostName: "www.apple.com")
        self.hostReachability.startNotifier()
        
        self.internetReachability = Reachability.reachabilityForInternetConnection()
        self.internetReachability.startNotifier()
        
        
        self.wifiReachability = Reachability.reachabilityForLocalWiFi()
        self.wifiReachability.startNotifier()

    }
    
    func reachabilityChanged(note:NSNotification){
        println("reachabilityChanged")
        var curReach:Reachability = note.object as! Reachability
        
        var netStatus:NetworkStatus = curReach.currentReachabilityStatus()
        var connectionRequired = curReach.connectionRequired()
        var statusString = "";
        println(netStatus.value)
        if netStatus.value == 0 {
            showNoticeText("没有可用网络！\(netStatus.value)")
        }else{
            showNoticeText("网络已连接！\(netStatus.value)")
        }
//        switch (netStatus)
//        {
//        case .NotReachable:
//            statusString = "Access Not Available"+"Text field text for access is not available"
//            /*
//            Minor interface detail- connectionRequired may return YES even when the host is unreachable. We cover that up here...
//            */
//            connectionRequired = NO;
//            break;
//        case .ReachableViaWWAN:
//            statusString = "Reachable WWAN"
//            break;
//            
//        case .ReachableViaWiFi:
//            statusString= "Reachable WiFi"
//            break;
//        }
        
        if (connectionRequired){
            println("%@, Connection Required"+"Concatenation of status string with connection requirement")
        }
    }

    func loadListLocal(localFileName:String)->Array<Vedio>{
         var list:Array<Vedio> = []
        var path:String = NSHomeDirectory()+"/Documents/"+localFileName
        println("localFilePath=\n\(path)")
        //判断本地是否存在该文件
        var isSongExists = NSFileManager.defaultManager().fileExistsAtPath(path)
        println("isFileExists = \(isSongExists)\n")
        
        //read local file
        if isSongExists{
            var data : NSData! = NSData(contentsOfFile: path)!
            //解压数据
            data = NSKeyedUnarchiver.unarchiveObjectWithFile(path) as! NSData
            if data != nil {
                var bdict:NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: nil) as!NSDictionary
                var c_array = bdict["data"] as! NSArray
                if c_array.count > 0 {
                    for dict in c_array{
                        var channel = Vedio(dictVedio: dict as! NSDictionary)
                        list.append(channel)
                    }
                }
            }
        }
        return list
    }
    func productHeadViewShowItem(channel: Vedio) {
        //self.performSegueWithIdentifier("AlbumDetailSegueId", sender: channel)
        self.performSegueWithIdentifier("ToVedioListVC", sender: channel)
    }
    
    func footerRefreshTableData(newVedio: Vedio) {
        self.relatedAlbumList.append(newVedio)
        self.productTableView.reloadData()
    }
    
    func historyViewShowItem(channel: Array<Vedio>!) {
        self.performSegueWithIdentifier("ToHistoryVC", sender: channel)
        //self.navigationController?.pushViewController(HistoryViewController(), animated: true)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var number = 0
        if section == 0 {
            number = self.relatedAlbumList.count
        }else if section == 1 {
            number = self.newAlbumList.count
        }
        return number
    }

    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        var height:CGFloat = 5
        if section == 0 {
            height = 30
        }else if section == 1 {
            height = 25
        }
        return height
    }
    
//    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        return UIButton.buttonWithType(UIButtonType.ContactAdd) as? UIView
//    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var title = ""
        if section == 0 {
            title = "推荐专辑"
        }else if section == 1 {
            title = "最新视频"
        }
        return title
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("IndexTVCellID", forIndexPath: indexPath) as? IndexTVCell
        var vedio:Vedio?
        if indexPath.section == 0 {
            vedio = self.relatedAlbumList[indexPath.row] as Vedio
        }else if indexPath.section == 1 {
            vedio = self.newAlbumList[indexPath.row] as Vedio
        }
        
        cell!.nameLabel.text = vedio!.name
        cell!.authorLabel.text = "作者："+vedio!.author
        cell!.palyTimesLabel.text = "播放次数：\(vedio!.playTimes)"
        cell!.playCostLabel.text = "爱苦逼：\(vedio!.playCost)"
        
        var imgurl:NSURL = NSURL(string: "")!
        if vedio!.defaultCover.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) != 0 {
            imgurl = NSURL(string:vedio!.defaultCover)!
        }else if vedio!.cover.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) != 0 {
            imgurl = NSURL(string:vedio!.cover)!
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
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        var channel:Vedio?
        if indexPath.section == 0 {
            channel = self.relatedAlbumList[indexPath.row]
        }else if indexPath.section == 1 {
            channel = self.newAlbumList[indexPath.row]
        }
        self.performSegueWithIdentifier("ToVedioListVC", sender: channel)
    }
    
    func getRelatedAlbumData(){
        var url = "http://www.icoolxue.com/album/recommend/10"
        HttpManagement.requestttt(url, method: "GET",bodyParam: nil,headParam:nil) { (repsone:NSHTTPURLResponse,data:NSData) -> Void in
            var bdict:NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: nil) as!NSDictionary
            //println(bdict)
            var code:Int = bdict["code"] as! Int
            if HttpManagement.HttpResponseCodeCheck(code, viewController: self){
                var c_array = bdict["data"] as! NSArray
                if c_array.count > 0 {
                    self.relatedAlbumList.removeAll(keepCapacity: true)
                    for dict in c_array{
                        var channel = Vedio(dictVedio: dict as! NSDictionary)
                        self.relatedAlbumList.append(channel)
                    }
                    self.productTableView.reloadData()
                    //将文件保存到本地(暂时理解为加压保存，使用时需解压)
                    var path = NSHomeDirectory()+"/Documents/IndexRelatedAlbumList"
                    NSKeyedArchiver.archiveRootObject(data, toFile: path)
                }
            }
        }
        /*
        var hm = HttpManagement()
        hm.requestttt2(url, method: "GET",bodyParam: nil,headParam:nil) { (repsone:NSHTTPURLResponse,data:NSData) -> Void in
            var bdict:NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: nil) as!NSDictionary
            //println(bdict)
            var code:Int = bdict["code"] as! Int
            if HttpManagement.HttpResponseCodeCheck(code, viewController: self){
                var c_array = bdict["data"] as! NSArray
                if c_array.count > 0 {
                    for dict in c_array{
                        var channel = Vedio(dictVedio: dict as! NSDictionary)
                        self.relatedAlbumList.append(channel)
                    }
                    self.productTableView.reloadData()
                }
            }
        }
        */
    }
    
    func getNewAlbumData(){
        var url = "http://www.icoolxue.com/album/last/10"
        HttpManagement.requestttt(url, method: "GET",bodyParam: nil,headParam:nil) { (repsone:NSHTTPURLResponse,data:NSData) -> Void in
            var bdict:NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: nil) as!NSDictionary
            //println(bdict)
            var code:Int = bdict["code"] as! Int
            if HttpManagement.HttpResponseCodeCheck(code, viewController: self){
                var c_array = bdict["data"] as! NSArray
                if c_array.count > 0 {
                    self.newAlbumList.removeAll(keepCapacity: true)
                    for dict in c_array{
                        var channel = Vedio(dictVedio: dict as! NSDictionary)
                        self.newAlbumList.append(channel)
                    }
                    self.productTableView.reloadData()
                    //将文件保存到本地(暂时理解为加压保存，使用时需解压)
                    var path = NSHomeDirectory()+"/Documents/IndexNewAlbumList"
                    NSKeyedArchiver.archiveRootObject(data, toFile: path)
                }
            }
        }
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier != nil {
            if segue.identifier! == "ToVedioListVC" {
                if sender?.isKindOfClass(Vedio) == true {
                    var adController:VedioListVC = segue.destinationViewController as! VedioListVC
                    adController.channel = sender as? Vedio
                }
            }else if segue.identifier! == "ToHistoryVC" {

            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
