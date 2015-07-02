
//
//  ProductFooterView.swift
//  CoolXuePlayer
//
//  Created by lion-mac on 15/6/11.
//  Copyright (c) 2015年 lion-mac. All rights reserved.
//

import Foundation

protocol LoadMoreFooterViewDelegate{
    func footerRefreshTableData(Channel)
}

class LoadMoreFooterView:UIView{
//    var delegate:ProductViewController!
    var delegate:LoadMoreFooterViewDelegate!
    @IBOutlet weak var nlLabel: UILabel!
    @IBOutlet weak var busy: UIActivityIndicatorView!
    @IBOutlet weak var moreView: UIView!
    @IBOutlet weak var btn: UIButton!
    //静态属性
    class var loadMoreFooterView:LoadMoreFooterView{
        get{
            //var nib:UINib = UINib(nibName: "ProductFooterView", bundle:NSBundle.mainBundle())
            //var footerView:ProductFooterView = nib.instantiateWithOwner(nil, options: nil).last as! ProductFooterView
            //return footerView
            return NSBundle.mainBundle().loadNibNamed("LoadMoreFooterView", owner: nil, options: nil).first as! LoadMoreFooterView
        }
    }

    @IBAction func doLoaderData(sender: UIButton) {
        println("load more")
        self.btn.hidden = true
        self.moreView.hidden = false
        self.busy.startAnimating()
        
//        var keyString : NSString = "one two three four five"
//        var keys : NSArray = keyString.componentsSeparatedByString(" ")
//        
//        
//        var valueString : NSString = "alpha bravo charlie delta echo"
//        var values : NSArray = valueString.componentsSeparatedByString(" ")
//        var dict:NSDictionary = NSDictionary(objects: keys as [AnyObject], forKeys: values as [AnyObject])
        
        var popTime:dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(NSEC_PER_MSEC.hashValue * 1000))
        
        dispatch_after(popTime, dispatch_get_main_queue()) { () -> Void in
            var dict:NSDictionary = NSDictionary(dictionary: [
                "affix":"c",
                "author":"c",
                "cover":"c",
                "createTimer":"c",
                "defaultCover":"c",
                "desc":"c",
                "id":9790,
                "name":"c",
                "playCost":"c",
                "tags":"c",
                "vedioUrl":"c",
                ])
            
            var newChannel:Channel = Channel(dictChannel: dict)
//            self.delegate.channelList.append(newChannel)
//            self.delegate.productTableView.reloadData()
            self.delegate.footerRefreshTableData(newChannel)
            
            self.btn.hidden = false
            self.moreView.hidden = true
            self.busy.stopAnimating()
        }
    }
    override func awakeFromNib() {
        //self.moreView.hidden = true
    }
}