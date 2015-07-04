//
//  VedioDescTV.swift
//  CoolXuePlayer
//
//  Created by lion-mac on 15/7/4.
//  Copyright (c) 2015年 lion-mac. All rights reserved.
//

import UIKit

class VedioDescTV: UITableView,UITableViewDataSource,UITableViewDelegate {
    var recommendAlbumList:Array<Channel> = []
    var theAlbumList:Array<Channel> = []
    var cuobj:Channel?
    
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

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        var height:CGFloat = 0
        if section == 1 {
            height = 22
        }else if section == 2 {
            height = 22
        }
        return height
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            var cell = tableView.dequeueReusableCellWithIdentifier("VedioDescTVCellID", forIndexPath: indexPath) as? VedioDescTVCell
            cell!.nameLabel.text = cuobj!.name
            cell!.authorLabel.text = "作者："+cuobj!.author
            cell!.releaseTimeLabel.text = "发布时间："+cuobj!.createTime
            cell!.playTimesLabel.text = "播放次数：99"
            cell!.descLabel.text = cuobj!.desc
            return cell!
        }else if indexPath.section == 1 {
            var cell = tableView.dequeueReusableCellWithIdentifier("VedioListTabVCellID", forIndexPath: indexPath) as? VedioListTabVCell
            var vedio = self.recommendAlbumList[indexPath.row] as Channel
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
        }else if indexPath.section == 2 {
            var cell = tableView.dequeueReusableCellWithIdentifier("VedioListTabVCellID", forIndexPath: indexPath) as? VedioListTabVCell
            var vedio = self.theAlbumList[indexPath.row] as Channel
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
        return UITableViewCell()
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var title = ""
        if section == 1 {
            title = "相关专辑"
        }else if section == 2 {
            title = "相关视频"
        }
        return title
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var number = 1
        if section == 0 {
            number = 1
        }else if section == 1 {
            number = self.recommendAlbumList.count
        }else if section == 2 {
            number = self.theAlbumList.count
        }
        return number
    }
    
    //获取推荐专辑
    func getRecommendAlbumData(){
        var urlkey_encoder = self.cuobj!.tags.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        var url = "http://www.icoolxue.com/related/album?keys=\(urlkey_encoder!)"
        HttpManagement.requestttt(url, method: "GET",bodyParam: nil,headParam:nil) { (repsone:NSHTTPURLResponse,data:NSData) -> Void in
            var bdict:NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: nil) as!NSDictionary
            //println(bdict)
            var code:Int = bdict["code"] as! Int
            if HttpManagement.HttpResponseCodeCheck(code, viewController: nil){
                var c_array = bdict["data"] as! NSArray
                if c_array.count > 0 {
                    for dict in c_array{
                        var vedio = Channel(dictChannel: dict as! NSDictionary)
                        self.recommendAlbumList.append(vedio)
                    }
                    if self.recommendAlbumList.count > 0 {
                        self.reloadData()
                    }
                }
            }
        }
    }
    
    //获取相关视频
    func getTheAlbumData(){
        var urlkey_encoder = self.cuobj!.tags.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        var url = "http://www.icoolxue.com/related/album?keys=\(urlkey_encoder!)"
        HttpManagement.requestttt(url, method: "GET",bodyParam: nil,headParam:nil) { (repsone:NSHTTPURLResponse,data:NSData) -> Void in
            var bdict:NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: nil) as!NSDictionary
            //println(bdict)
            var code:Int = bdict["code"] as! Int
            if HttpManagement.HttpResponseCodeCheck(code, viewController: nil){
                var c_array = bdict["data"] as! NSArray
                if c_array.count > 0 {
                    for dict in c_array{
                        var vedio = Channel(dictChannel: dict as! NSDictionary)
                        self.theAlbumList.append(vedio)
                    }
                    if self.theAlbumList.count > 0 {
                        self.reloadData()
                    }
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
