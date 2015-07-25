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
    var cache_relatedAlbum_path = "/Documents/IndexRelatedAlbumList"
    var cache_newAlbum_path = "/Documents/IndexNewAlbumList"
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
        
        var relatedAlbumList:Array<Vedio>! = DataHelper.getVideoList(DataHelper.ReadDate(self.cache_relatedAlbum_path)) as! Array<Vedio>
        
        //var relatedAlbumList:Array<Vedio>! = self.loadListLocal("IndexRelatedAlbumList")
        if relatedAlbumList != nil && relatedAlbumList.count > 0 {
            self.relatedAlbumList = relatedAlbumList
        }
        var newAlbumList:Array<Vedio>! = DataHelper.getVideoList(DataHelper.ReadDate(self.cache_newAlbum_path)) as! Array<Vedio>
        
        //var newAlbumList:Array<Vedio>! = self.loadListLocal("IndexNewAlbumList")
        if newAlbumList != nil && newAlbumList.count > 0 {
            self.newAlbumList = newAlbumList
        }
        //有网络才请求数据
        if NetWorkHelper.is_network_ok == true {
            println("Network Connection: Available")
            LoginTool.autoLogin()
            //推荐
            //self.getRelatedAlbumData()
            //最新
            //self.getNewAlbumData()
        } else {
            println("Network Connection: Unavailable")
            D3Notice.showText("没有可用网络！",time:D3Notice.longTime,autoClear:true)
        }
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
            var code:Int = bdict["code"] as! Int
            if HttpManagement.HttpResponseCodeCheck(code, viewController: self){
                self.relatedAlbumList = DataHelper.getVideoList(bdict) as! Array<Vedio>
                if self.relatedAlbumList.count > 0 {
                    self.productTableView.reloadData()
                    //将文件保存到本地
                    DataHelper.CacheData(self.cache_relatedAlbum_path, data: data)
                }
            }
        }
    }
    
    func getNewAlbumData(){
        var url = "http://www.icoolxue.com/album/last/10"
        HttpManagement.requestttt(url, method: "GET",bodyParam: nil,headParam:nil) { (repsone:NSHTTPURLResponse,data:NSData) -> Void in
            var bdict:NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: nil) as!NSDictionary
            //println(bdict)
            var code:Int = bdict["code"] as! Int
            if HttpManagement.HttpResponseCodeCheck(code, viewController: self){
                self.newAlbumList = DataHelper.getVideoList(bdict) as! Array<Vedio>
                if self.newAlbumList.count > 0 {
                    self.productTableView.reloadData()
                    //将文件保存到本地
                    DataHelper.CacheData(self.cache_newAlbum_path, data: data)
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