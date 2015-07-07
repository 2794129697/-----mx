//
//  VedioDescTV.swift
//  CoolXuePlayer
//
//  Created by lion-mac on 15/7/4.
//  Copyright (c) 2015年 lion-mac. All rights reserved.
//

import UIKit
import Foundation

protocol VedioDescTVDelegate{
    func turnToVedioListView(vedio:Vedio)
}

class VedioDescTV: UITableView,UITableViewDataSource,UITableViewDelegate {
    var relatedAlbumList:Array<Vedio> = []
    var relatedVedioList:Array<Vedio> = []
    var relatedBookList:Array<Vedio> = []
    var cuobj:Vedio?
    var gotoViewDelegate:VedioDescTVDelegate?
    
    override func awakeFromNib() {
        if self.delegate == nil {
            var nib1 = UINib(nibName: "VedioDescTVCell", bundle: nil)
            var nib2 = UINib(nibName: "VedioListTabVCell", bundle: nil)
            self.registerNib(nib1, forCellReuseIdentifier: "VedioDescTVCellID")
            self.registerNib(nib2, forCellReuseIdentifier: "VedioListTabVCellID")
            
            // 经过测试，实际表现及运行效率均相似，大👍
            self.estimatedRowHeight = 148
            self.rowHeight = UITableViewAutomaticDimension
            self.dataSource = self
            self.delegate = self
        }
    }
    
    func showVedioDetailInfo(vedio:Vedio){
        println(self.contentOffset)
        //有动画效果不能每次回到0,0(有时正确)
        self.setContentOffset(CGPointMake(0, 0), animated: false)
        self.cuobj = vedio
        //获取推荐专辑
        self.getRelatedAlbumData()
        //获取相关视频
        self.getRelatedVideoData()
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var number = 1
        if section == 0 {
            number = 1
        }else if section == 1 {
            number = self.relatedAlbumList.count
        }else if section == 2 {
            number = self.relatedVedioList.count
        }else if section == 3 {
            number = self.relatedBookList.count
        }
        return number
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        var height:CGFloat = 5
        if section == 0 {
            height = 5
        }else{
            height = 22
        }
        return height
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var title = ""
        if section == 1 {
            title = "猜你喜欢"
        }else if section == 2 {
            title = "相关视频"
        }else if section == 3 {
            title = "相关书籍"
        }
        return title
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            var cell = tableView.dequeueReusableCellWithIdentifier("VedioDescTVCellID", forIndexPath: indexPath) as? VedioDescTVCell
            cell!.nameLabel.text = cuobj!.name
            cell!.authorLabel.text = "作者："+cuobj!.author
            cell!.releaseTimeLabel.text = "发布时间："+cuobj!.createTime
            cell!.playTimesLabel.text = "播放次数：\(cuobj!.playTimes)"
            cell!.descLabel.text = cuobj!.desc
            return cell!
        }else if indexPath.section == 1 {
            var cell = tableView.dequeueReusableCellWithIdentifier("VedioListTabVCellID", forIndexPath: indexPath) as? VedioListTabVCell
            var vedio = self.relatedAlbumList[indexPath.row] as Vedio
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
        }else if indexPath.section == 2 {
            var cell = tableView.dequeueReusableCellWithIdentifier("VedioListTabVCellID", forIndexPath: indexPath) as? VedioListTabVCell
            var vedio = self.relatedVedioList[indexPath.row] as Vedio
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
        }else if indexPath.section == 3 {
            var cell = tableView.dequeueReusableCellWithIdentifier("VedioListTabVCellID", forIndexPath: indexPath) as? VedioListTabVCell
            var vedio = self.relatedBookList[indexPath.row] as Vedio
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
        return UITableViewCell()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        //看猜你喜欢
        if indexPath.section == 1 && self.gotoViewDelegate != nil {
            var vedio:Vedio = self.relatedAlbumList[indexPath.row]
            self.gotoViewDelegate!.turnToVedioListView(vedio)
        //相关视频
        }else if indexPath.section == 2 {
            var vedio:Vedio? = self.relatedVedioList[indexPath.row]
            if vedio != nil {
                self.cuobj = vedio
                //获取视频播放地址
                var url = "http://www.icoolxue.com/video/play/url/"+String(vedio!.id)
                self.getVedioPlayUrl(url)
            }
        }else if indexPath.section == 3 {
            println("相关书籍")
        }
    }
    
    //获取推荐专辑
    func getRelatedAlbumData(){
        var urlkey_encoder = self.cuobj!.tags.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        var url = "http://www.icoolxue.com/related/album?keys=\(urlkey_encoder!)"
        HttpManagement.requestttt(url, method: "GET",bodyParam: nil,headParam:nil) { (repsone:NSHTTPURLResponse,data:NSData) -> Void in
            var bdict:NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: nil) as!NSDictionary
            //println(bdict)
            var code:Int = bdict["code"] as! Int
            if HttpManagement.HttpResponseCodeCheck(code, viewController: self.gotoViewDelegate as! VedioPlayerViewController){
                var c_array = bdict["data"] as! NSArray
                if c_array.count > 0 {
                    self.relatedAlbumList.removeAll(keepCapacity: true)
                    for dict in c_array{
                        var vedio = Vedio(dictVedio: dict as! NSDictionary)
                        self.relatedAlbumList.append(vedio)
                    }
                    if self.relatedAlbumList.count > 0 {
                        self.reloadData()
                    }
                }
            }
        }
    }
    
    //获取相关视频
    func getRelatedVideoData(){
        var url = "http://www.icoolxue.com/album/similar/\(self.cuobj!.affix!)/10"
        HttpManagement.requestttt(url, method: "GET",bodyParam: nil,headParam:nil) { (repsone:NSHTTPURLResponse,data:NSData) -> Void in
            //println(NSString(data: data, encoding: NSUTF8StringEncoding))
            var bdict:NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: nil) as!NSDictionary
            //println(bdict)
            var code:Int = bdict["code"] as! Int
            if HttpManagement.HttpResponseCodeCheck(code, viewController: self.gotoViewDelegate as! VedioPlayerViewController){
                var c_array = bdict["data"] as! NSArray
                if c_array.count > 0 {
                    self.relatedVedioList.removeAll(keepCapacity: true)
                    for dict in c_array{
                        var vedio = Vedio(dictVedio: dict as! NSDictionary)
                        self.relatedVedioList.append(vedio)
                    }
                    if self.relatedVedioList.count > 0 {
                        self.reloadData()
                    }
                }
            }
        }
    }
    
    //获取相关图书
    func getRelatedBookData(){
        var urlkey_encoder = self.cuobj!.tags.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        var url = "http://www.icoolxue.com/related/book?keys=\(urlkey_encoder!)"
        HttpManagement.requestttt(url, method: "GET",bodyParam: nil,headParam:nil) { (repsone:NSHTTPURLResponse,data:NSData) -> Void in
            //println(NSString(data: data, encoding: NSUTF8StringEncoding))
            var bdict:NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: nil) as!NSDictionary
            //println(bdict)
            var code:Int = bdict["code"] as! Int
            if HttpManagement.HttpResponseCodeCheck(code, viewController: self.gotoViewDelegate as! VedioPlayerViewController){
                var c_array = bdict["data"] as! NSArray
                if c_array.count > 0 {
                    self.relatedBookList.removeAll(keepCapacity: true)
                    for dict in c_array{
                        var vedio = Vedio(dictVedio: dict as! NSDictionary)
                        self.relatedBookList.append(vedio)
                    }
                    if self.relatedBookList.count > 0 {
                        self.reloadData()
                    }
                }
            }
        }
    }

    func getVedioPlayUrl(path:String){
        //println("request url = \(path)")
        var headerParam:Dictionary<String,String> = ["referer":"http://www.icoolxue.com"]
        HttpManagement.requestttt(path, method: "GET",bodyParam: nil,headParam:headerParam) { (repsone:NSHTTPURLResponse,data:NSData) -> Void in
            var bdict:NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: nil) as!NSDictionary
            //println(bdict)
            var code:Int = bdict["code"] as! Int
            if HttpManagement.HttpResponseCodeCheck(code, viewController: nil){
                var vedio_url = bdict["data"] as? String
                if vedio_url != nil {
                    self.cuobj?.vedioUrl = vedio_url
                    NSNotificationCenter.defaultCenter().postNotificationName("ReloadView", object: self.cuobj)
                }else{
                    println("Failed to Get Url!!!!!!!!")
                    var alert:UIAlertView = UIAlertView(title: "提示", message: "获取视频播放地址失败！", delegate: self, cancelButtonTitle: "确定")
                    alert.show()
                }
            }
        }
    }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
