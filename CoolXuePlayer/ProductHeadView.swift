

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
    static var topAlbumList:Array<Vedio>?
    static var headViews:Array<ScrollContentView> = []
    
    @IBAction func bnOfflineClicked(sender: UIButton) {
        
    }
    
    @IBAction func bnFavClicked(sender: UIButton) {
        
    }

    @IBAction func bnHistoryClicked(sender: UIButton) {
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
        //有网络才请求数据
        if NetWorkHelper.is_network_ok == true {
            //获取最热专辑数据
            self.getTopAlbumData()
        }
    }

    func loadImage(list:Array<Vedio>){
        self.pageControl.numberOfPages = list.count
        //加载图片
        var imgViewY:CGFloat = 0
        var imgViewW:CGFloat = self.scrollView.frame.width
        var imgViewH:CGFloat = self.scrollView.frame.height
        var img_show_w:CGFloat = 124
        
        for(var i:Int = 0;i<list.count;i++){
            var movePo:Vedio = list[i]
            
            var imgurl = movePo.defaultCover
            if imgurl == nil {
                imgurl = movePo.cover
            }
            
            var xibView:ScrollContentView?
            if ProductHeadView.headViews.count > 0 && i + 1 <= ProductHeadView.headViews.count {
                xibView = ProductHeadView.headViews[i]
            }
            if xibView == nil {
                xibView = ScrollContentView.scrollContentView
                ProductHeadView.headViews.append(xibView!)
                self.scrollView.addSubview(xibView!)
            }
            xibView!.userInteractionEnabled = true

            var imgViewX:CGFloat = imgViewW * CGFloat(i)
            xibView!.frame = CGRectMake(imgViewX, imgViewY,imgViewW, imgViewH)
            xibView!.imageView.sd_setImageWithURL(NSURL(string: imgurl), completed: { (image:UIImage!, error:NSError!, cacheType:SDImageCacheType, url:NSURL!) -> Void in
                        //println(image.size)
                    })
//            //将图像变圆形
//            xibView!.imageView.layer.cornerRadius = 100/2
//            xibView!.imageView.clipsToBounds=true

//            //图片模糊
//            var blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
//            var blurView = UIVisualEffectView(effect: blurEffect)
//            blurView.frame = xibView.imageView.bounds
//            xibView!.imageView.addSubview(blurView)
            
            xibView!.nameLabel.text = movePo.name
            
            var bn:UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
            //bn.setTitle("点击看看", forState: UIControlState.Normal)
            bn.frame = xibView!.frame
            bn.addTarget(self, action: Selector("showAlbumInfo:"), forControlEvents: UIControlEvents.TouchUpInside)
            bn.tag = i
            self.scrollView.addSubview(bn)
        }
        scrollView.contentSize = CGSize(width: imgViewW*CGFloat(list.count), height: imgViewH)
    }
    
    func showAlbumInfo(sender:UIButton){
        println("showAlbumInfo")
        var id:Int = sender.tag
        var channel:Vedio = ProductHeadView.topAlbumList![id]
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
    
    //获取最热专辑数据
    func getTopAlbumData(){
        //println("1111self.recommendList== nil is \(ProductHeadView.recommendList == nil)")
        if ProductHeadView.topAlbumList == nil {
            ProductHeadView.topAlbumList = []
            
            var topAlbumList:Array<Vedio>! = self.loadListLocal("IndexTopAlbumList")
            if topAlbumList != nil && topAlbumList.count > 0 {
                ProductHeadView.topAlbumList = topAlbumList
            }
            if ProductHeadView.topAlbumList!.count > 0 {
                self.loadImage(ProductHeadView.topAlbumList!)
            }

            var url = "http://www.icoolxue.com/album/top/10"
            HttpManagement.requestttt(url, method: "GET",bodyParam: nil,headParam:nil) { (repsone:NSHTTPURLResponse,data:NSData) -> Void in
                if repsone.statusCode == 200 {
                    var bdict:NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: nil) as!NSDictionary
                    //println(bdict)
                    var c_array = bdict["data"] as! NSArray
                    if c_array.count > 0 {
                        ProductHeadView.topAlbumList?.removeAll(keepCapacity: true)
                        for dict in c_array{
                            var album = Vedio(dictVedio: dict as! NSDictionary)
                            ProductHeadView.topAlbumList!.append(album)
                        }
                        self.loadImage(ProductHeadView.topAlbumList!)
                        //将文件保存到本地(暂时理解为加压保存，使用时需解压)
                        var path = NSHomeDirectory()+"/Documents/IndexTopAlbumList"
                        NSKeyedArchiver.archiveRootObject(data, toFile: path)
                    }
                }
            }
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
}