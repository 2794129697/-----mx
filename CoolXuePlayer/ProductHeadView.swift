

//
//  ProductHeadView.swift
//  CoolXuePlayer
//
//  Created by lion-mac on 15/6/1.
//  Copyright (c) 2015年 lion-mac. All rights reserved.
//

import Foundation
import UIKit

protocol ProductHeadViewDelegate{
    func productHeadViewShowItem(channel:Vedio)
    func historyViewShowItem(channel:Array<Vedio>!)
}


class ProductHeadView:UIView,UIScrollViewDelegate{
    var delegate:ProductHeadViewDelegate!
    @IBOutlet weak var bnHistory: UIButton!
    @IBOutlet weak var bnOffline: UIButton!
    @IBOutlet weak var bnFav: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    static var recommendList:Array<Vedio>?
    
    @IBAction func bnOfflineClicked(sender: UIButton) {
        
    }
    
    @IBAction func bnFavClicked(sender: UIButton) {
        
    }

    @IBAction func bnHistoryClicked(sender: UIButton) {
//        var url = "http://www.icoolxue.com/video/log/my/1/10"
//        self.getHistoryData(url)
        self.delegate?.historyViewShowItem(nil)
    }
    
    func getViewController()->ProductViewController{
        var viewCon:ProductViewController?
        var res:UIResponder = self.nextResponder()!
        do{
            res = res.nextResponder()!
            if res.isKindOfClass(ProductViewController){
                viewCon = res as?ProductViewController
                //viewCon.performSegueWithIdentifier("HistorySugueId", sender: channel)
                break
            }
            //println(res)
        }while !res.isKindOfClass(AppDelegate)
        return viewCon!
    }
    
    func getHistoryData(url:String){
        HttpManagement.requestttt(url, method: "GET",bodyParam: nil,headParam:nil) { (repsone:NSHTTPURLResponse,data:NSData) -> Void in
            var bdict:NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: nil) as!NSDictionary
            //println(bdict)
            var code:Int = bdict["code"] as! Int
             var viewCon:ProductViewController = self.getViewController()
            println(viewCon)
            if HttpManagement.HttpResponseCodeCheck(code, viewController: viewCon){
                var dict = bdict["data"] as! NSDictionary
                var c_array = dict["data"] as! NSArray
                var channelList:Array<Vedio> = []
                if c_array.count > 0 {
                    for dict in c_array{
                        //println(dict["video"])
                        var channel = Vedio(dictVedio: dict["video"] as! NSDictionary)
                        channelList.append(channel)
                    }
                    self.delegate?.historyViewShowItem(channelList)
                }
            }
        }
    }

    //用户拖动时一直会调用
    func scrollViewDidScroll(scrollView: UIScrollView) {
        //println("scrollViewDidScroll")
        var offset:CGPoint = self.scrollView.contentOffset
        var currPage = (self.scrollView.contentOffset.x + self.scrollView.frame.width*0.5)/self.scrollView.frame.width
        self.pageControl.currentPage = Int(currPage)
    }
    
    //开始拖拽时调用
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        //println("scrollViewWillBeginDragging")

    }
    
    //拖拽结束时调用
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        //println("scrollViewDidEndDragging")
        var currPage = (self.scrollView.contentOffset.x + self.scrollView.frame.width*0.5)/self.scrollView.frame.width
        self.pageControl.currentPage = Int(currPage)
    }
    
    override func awakeFromNib() {
        scrollView.pagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = true
        scrollView.bounces = false
        scrollView.scrollEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.indicatorStyle = UIScrollViewIndicatorStyle.Default
        self.scrollView.delegate = self
        //获取数据
        getRecommendData()
    }
    func xdddgg(af:UITapGestureRecognizer){
        println("xdfsd")
    }
    func loadImage(list:Array<Vedio>){
        self.pageControl.numberOfPages = list.count
        //加载图片
        var imgViewY:CGFloat = 0
        var imgViewW:CGFloat = self.scrollView.frame.width
        var imgViewH:CGFloat = self.scrollView.frame.height
        var img_show_w:CGFloat = 124
        println(self.scrollView.frame.height)
        println(self.scrollView.bounds.height)
        
        for(var i:Int = 0;i<list.count;i++){
            var movePo:Vedio = list[i]
            
            var imgurl = movePo.defaultCover
            if imgurl == nil {
                imgurl = movePo.cover
            }
            
            var xibView:ScrollContentView = ScrollContentView.scrollContentView
            xibView.userInteractionEnabled = true
            var uig = UITapGestureRecognizer(target: self, action: "xdddgg")
            xibView.addGestureRecognizer(uig)
            var imgViewX:CGFloat = imgViewW * CGFloat(i)
            xibView.frame = CGRectMake(imgViewX, imgViewY,imgViewW, imgViewH)
            xibView.imageView.sd_setImageWithURL(NSURL(string: imgurl), completed: { (image:UIImage!, error:NSError!, cacheType:SDImageCacheType, url:NSURL!) -> Void in
                        //println(image.size)
                    })
//            //将图像变圆形
//            xibView.imageView.layer.cornerRadius = 100/2
//            xibView.imageView.clipsToBounds=true

            xibView.nameLabel.text = movePo.name
            self.scrollView.addSubview(xibView)
            
            var bn:UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
            //bn.setTitle("点击看看", forState: UIControlState.Normal)
            bn.frame = xibView.frame
            bn.addTarget(self, action: Selector("showInfo:"), forControlEvents: UIControlEvents.TouchUpInside)
            //bn.setValue(movePo, forUndefinedKey: "channelobj")
            //bn.setValue(movePo, forKey: "channelobj")
            bn.tag = i
            self.scrollView.addSubview(bn)
            
        }
        scrollView.contentSize = CGSize(width: imgViewW*CGFloat(list.count), height: imgViewH)
    }
    
    func showInfo(sender:UIButton){
        println("dididi")
        //var channel:Vedio = sender.valueForKey("channelobj") as! Vedio
        //println(channel)
        var id:Int = sender.tag
        var channel:Vedio = ProductHeadView.recommendList![id]
        println(channel.name)
        self.delegate?.productHeadViewShowItem(channel)
    }
    
    //静态属性
    class var productHeadView:ProductHeadView{
        get{
          return NSBundle.mainBundle().loadNibNamed("ProductHeadView", owner: nil, options: nil).first as! ProductHeadView
        }
    }
    
//    //从plist中取数据
//    /*
//    *数据懒加载
//    */
//    var _moviePOArray:NSMutableArray!
//    var moviePOArray:NSMutableArray{
//        get{
//            if self._moviePOArray == nil {
//                var path:String = NSBundle.mainBundle().pathForResource("moviepics", ofType: "plist")!
//                var dictArray:NSMutableArray = NSMutableArray(contentsOfFile: path)!
//                self._moviePOArray = NSMutableArray()
//                for dict in dictArray{
//                    var moviePO:MoviePO = MoviePO(dict: dict as! NSMutableDictionary)
//                    self._moviePOArray.addObject(moviePO)
//                }
//            }
//            return self._moviePOArray
//        }
//    }
    
    func getRecommendData(){
        //println("1111self.recommendList== nil is \(ProductHeadView.recommendList == nil)")
        if ProductHeadView.recommendList == nil {
            ProductHeadView.recommendList = []
            var url = "http://www.icoolxue.com/album/top/10"
            HttpManagement.requestttt(url, method: "GET",bodyParam: nil,headParam:nil) { (repsone:NSHTTPURLResponse,data:NSData) -> Void in
                if repsone.statusCode == 200 {
                    var bdict:NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: nil) as!NSDictionary
                    //println(bdict)
                    var c_array = bdict["data"] as! NSArray
                    if c_array.count > 0 {
                        for dict in c_array{
                            var channel = Vedio(dictVedio: dict as! NSDictionary)
                            ProductHeadView.recommendList!.append(channel)
                        }
                        self.loadImage(ProductHeadView.recommendList!)
                    }
                }
            }
            
//            var channel_url = "http://www.icoolxue.com/album/recommend/8"
//            var url = NSURL(string: channel_url)
//            var request = NSURLRequest(URL: url!)
//            var mainQueue = NSOperationQueue.mainQueue()
//            
//            NSURLConnection.sendAsynchronousRequest(request,queue: mainQueue, completionHandler: { (response:NSURLResponse!, data:NSData!, error:NSError!) -> Void in
//                var httpResponse = response as! NSHTTPURLResponse
//                if httpResponse.statusCode == 200 {
//                    var bdict:NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: nil) as!NSDictionary
//                    //println(bdict)
//                    var c_array = bdict["data"] as! NSArray
//                    if c_array.count > 0 {
//                        for dict in c_array{
//                            var channel = Vedio(dictVedio: dict as! NSDictionary)
//                            ProductHeadView.recommendList!.append(channel)
//                        }
//                        self.loadImage(ProductHeadView.recommendList!)
//                    }
//                }
//
//            })
        }
    }
    
    
    
}