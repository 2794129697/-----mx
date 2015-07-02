//
//  DiyTableCellViewController.swift
//  CoolXuePlayer
//
//  Created by lion-mac on 15/5/30.

//

import UIKit

class DiyTableCellViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate {
    
    @IBOutlet weak var channelTableView: UITableView!
    var channelList:Array<Channel> = []
    var otherViewCell:Int = 3
    var scrollView:UIScrollView?
    var pageControl:UIPageControl?
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
                        }
                        self.channelTableView.reloadData()
                    }
                }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        getChannelData()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.channelList.count + self.otherViewCell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        ////动态获取cell的高报错，搞不懂
        //var cell = tableView.cellForRowAtIndexPath(indexPath)
        //return cell!.frame.size.height
        
        var height:CGFloat = 60
        if indexPath.row == 0 {
            height = 160
        }else if indexPath.row == 1 {
            height = 160
        }else if indexPath.row == 2 {
            height = 60
        }
        return height
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell!
        if indexPath.row == 0 {
            cell = tableView.dequeueReusableCellWithIdentifier("cell1", forIndexPath: indexPath) as! UITableViewCell
            if !self.is_initScrollView{
                self.scrollView = cell.contentView.viewWithTag(1) as? UIScrollView
                self.pageControl = cell.contentView.viewWithTag(2) as? UIPageControl
            
                self.is_initScrollView = true
                initScrollView()
            }
            //println("self.scrollView=\n\(self.scrollView)")
            //println("self.pageControl=\n\(self.pageControl)")
            

        }else if indexPath.row == 1 {
            cell = tableView.dequeueReusableCellWithIdentifier("cell2", forIndexPath: indexPath) as! UITableViewCell
        }else if indexPath.row == 2 {
            cell = tableView.dequeueReusableCellWithIdentifier("cell3", forIndexPath: indexPath) as! UITableViewCell
        }else{
            cell = tableView.dequeueReusableCellWithIdentifier("cell4", forIndexPath: indexPath) as! UITableViewCell
            var channel = self.channelList[indexPath.row - self.otherViewCell]
            if channel.name == nil {
                return cell
            }
            //cell.textLabel?.text = String(indexPath.row)+channel.name
            cell.textLabel?.text = String(indexPath.row)+"测试"
            var imgurl:NSURL = NSURL(string: "")!
            if channel.defaultCover != nil {
                imgurl = NSURL(string:channel.defaultCover)!
            }else if channel.cover != nil {
                imgurl = NSURL(string:channel.cover)!
            }
            println("imgurl=\(imgurl)")
            cell.imageView?.sd_setImageWithURL(imgurl, placeholderImage: UIImage(named: "cache_p.png"), options: SDWebImageOptions.ContinueInBackground, progress: { (a:Int, b:Int) -> Void in
                println("image pross=\(a/b)")
                }, completed: { (image:UIImage!, error:NSError!, cacheType:SDImageCacheType, imgurl:NSURL!) -> Void in
                    println("cached finished")
            })

        }
        //cell.textLabel?.text = "hello"+String(indexPath.row)
        return cell
    }
    
    
    
    
    
    //--------------------UICollectionView
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier("cccell1", forIndexPath: indexPath) as! UICollectionViewCell
        var imgView = cell.contentView.viewWithTag(1) as! UIImageView
        imgView.image = UIImage(named: "channel_0_s.png")
        var lb = cell.contentView.viewWithTag(2) as! UILabel
        lb.text = String(indexPath.row)
        return cell
    }
    
    //---------------------ScrollView
    var pageImages: [UIImage] = []
    var pageViews: [UIImageView?] = []
    var is_initScrollView:Bool = false
    func loadPage(page: Int) {
        if page < 0 || page >= pageImages.count {
            // 如果超出了页面显示的范围，什么也不需要做
            return
        }
        
        // 1
        if let pageView = pageViews[page] {
            // 页面已经加载，不需要额外操作
        } else {
            // 2
            var frame = scrollView!.bounds
            frame.origin.x = frame.size.width * CGFloat(page)
            frame.origin.y = 0.0
            
            // 3
            //            let newPageView = UIImageView(image: pageImages[page])
            //            newPageView.contentMode = .ScaleAspectFit
            //            newPageView.frame = frame
            
            let newPageView = UIImageView()
            newPageView.sd_setImageWithURL(NSURL(string: "http://media.icoolxue.com/M87ExoMcDKdQ3K9DxVYLJo.jpg"))
            newPageView.contentMode = .ScaleAspectFit
            newPageView.frame = frame
            scrollView!.addSubview(newPageView)
            
            // 4
            pageViews[page] = newPageView
        }
    }
    
    func purgePage(page: Int) {
        if page < 0 || page >= pageImages.count {
            // 如果超出要显示的范围，什么也不做
            return
        }
        
        // 从scrollView中移除页面并重置pageViews容器数组响应页面
        if let pageView = pageViews[page] {
            pageView.removeFromSuperview()
            pageViews[page] = nil
        }
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        println("aaaaa")
    }
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        println("bbbbb")
    }
    func scrollViewDidEndZooming(scrollView: UIScrollView, withView view: UIView!, atScale scale: CGFloat) {
        println("cccc")
    }
    func scrollViewDidScrollToTop(scrollView: UIScrollView) {
        println("ddddd")
    }
    
    func scrollViewDidScroll(scrollV: UIScrollView) {
        // Load the pages that are now on screen
        //println(self.scrollView)

            if self.scrollView != nil && self.pageControl != nil{
                loadVisiblePages()
            }
        
    }
    
    func initScrollView() {
        println("initScrollView--------------")
        // 1
        pageImages.append(UIImage(named: "defaut_logo_zongyi.png")!)
        pageImages.append(UIImage(named: "default_hoder114x152.jpg")!)
        pageImages.append(UIImage(named: "defaut_logo_zongyi.png")!)
        pageImages.append(UIImage(named: "default_hoder_170x100.jpg")!)
        pageImages.append(UIImage(named: "default_hoder_295x165.jpg")!)
        //        pageImages = [
        //            UIImage(named: "photo1.png"),
        //            UIImage(named: "photo2.png"),
        //            UIImage(named: "photo3.png"),
        //            UIImage(named: "photo4.png"),
        //            UIImage(named: "photo5.png")
        //        ]
        
        let pageCount = pageImages.count
        
        // 2
        pageControl!.currentPage = 0
        pageControl!.numberOfPages = pageCount
        
        // 3
        for _ in 0..<pageCount {
            pageViews.append(nil)
        }
        
        // 4
        let pagesScrollViewSize = scrollView!.frame.size
        scrollView!.contentSize = CGSize(width: pagesScrollViewSize.width * CGFloat(pageImages.count),
            height: pagesScrollViewSize.height)
        
        // 5
        loadVisiblePages()
        // Do any additional setup after loading the view.
    }
    
    func loadVisiblePages() {
        // 首先确定当前可见的页面
        let pageWidth = scrollView!.frame.size.width
        let page = Int(floor((scrollView!.contentOffset.x * 2.0 + pageWidth) / (pageWidth * 2.0)))
        
        // 更新pageControl
        pageControl!.currentPage = page
        
        // 计算那些页面需要加载
        let firstPage = page - 1
        let lastPage = page + 1
        
        // 清理firstPage之前的所有页面
        for var index = 0; index < firstPage; ++index {
            purgePage(index)
        }
        
        // 加载范围内（firstPage到lastPage之间）的所有页面
        for index in firstPage...lastPage {
            loadPage(index)
        }
        
        // 清理lastPage之后的所有页面
        for var index = lastPage+1; index < pageImages.count; ++index {
            purgePage(index)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
