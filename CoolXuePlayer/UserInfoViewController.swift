//
//  UserInfoViewController.swift
//  CoolXuePlayer
//
//  Created by lion-mac on 15/6/3.
//  Copyright (c) 2015年 lion-mac. All rights reserved.
//

import UIKit

class UserInfoViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UserInfoHeadViewDelegate {
    @IBOutlet weak var collectionView: UICollectionView!
    func loginOrLoginOut() {
        self.performSegueWithIdentifier("VedioViewToLogin", sender: nil)
    }
    var items:Array<NSDictionary> = [
        ["name":"本地视频","info":"共0个"],
        ["name":"我的收藏","info":"共0个"],
        ["name":"播放历史","info":"共0个"],
        ["name":"设置","info":"系统设置"]
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        //self.getUserInfo("http://www.icoolxue.com/account/my")
    }
    
    func getUserInfo(url:String){
        HttpManagement.requestttt(url, method: "GET",bodyParam: nil,headParam:nil) { (repsone:NSHTTPURLResponse,data:NSData) -> Void in
            var bdict:NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: nil) as!NSDictionary
            //println(bdict)
            var code:Int = bdict["code"] as! Int
            if HttpManagement.HttpResponseCodeCheck(code, viewController: self){
                var dict = bdict["data"] as! NSDictionary
               println(dict)
            }
        }
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell:UserInfoCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("CollectionId", forIndexPath: indexPath) as! UserInfoCollectionViewCell
        var dict = self.items[indexPath.row]
        cell.infoLabel.text = dict["info"] as? String
        cell.nameLabel.text = dict["info"] as? String
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        var reusableview:UICollectionReusableView?
        if (kind == UICollectionElementKindSectionHeader){
            var headerView = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "CollectionHeaderView", forIndexPath: indexPath) as! UserInfoHeadView
            headerView.delegate = self
            if LoginTool.isNeedUserLogin {
                headerView.userNameLabel.text = "点击登录"
            }else{
                headerView.userNameLabel.text = "瑰丽呃"
            }
            reusableview = headerView;
        }
        
        if (kind == UICollectionElementKindSectionFooter){
            
        }
        return reusableview!
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        println("xxx")
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
}
