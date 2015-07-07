//
//  CategoryViewController.swift
//  CoolXuePlayer
//
//  Created by lion-mac on 15/6/18.
//  Copyright (c) 2015年 lion-mac. All rights reserved.
//

import UIKit

class CategoryViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate{
    @IBOutlet weak var ACategoryTableView: UITableView!
    @IBOutlet weak var BCategoryCollectionView: UICollectionView!
    var aCategoryList:Array<Category> = []
    var currACategoryList:Array<CategorySub> = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ACategoryTableView.dataSource = self
        self.ACategoryTableView.delegate = self
        self.ACategoryTableView.showsVerticalScrollIndicator = false
        self.BCategoryCollectionView.dataSource = self
        self.BCategoryCollectionView.delegate = self
        self.getCategoryData()
    }
    
    func getCategoryData(){
        var url = "http://www.icoolxue.com/category"
        HttpManagement.requestttt(url, method: "GET",bodyParam: nil,headParam:nil) { (repsone:NSHTTPURLResponse,data:NSData) -> Void in
//            var str = NSString(data: data, encoding: NSUTF8StringEncoding)
//            println(str)
            var bdict:NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: nil) as!NSDictionary
            // println(bdict)
            var code:Int = bdict["code"] as! Int
            if HttpManagement.HttpResponseCodeCheck(code, viewController: self){
                var c_array = bdict["data"] as! NSArray
                if c_array.count > 0 {
                    for dict in c_array{
                        var category = Category(dict: dict as! NSDictionary)
                        self.aCategoryList.append(category)
                        if self.currACategoryList.count == 0 {
                            self.currACategoryList = category.subCategoryList!
                        }
                    }
                    self.ACategoryTableView.reloadData()
                    self.ACategoryTableView.selectRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), animated: true, scrollPosition: UITableViewScrollPosition.Bottom)
                    self.BCategoryCollectionView.reloadData()
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.aCategoryList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell!
        cell = tableView.dequeueReusableCellWithIdentifier("ACategoryCellID", forIndexPath: indexPath) as! UITableViewCell
        var data = self.aCategoryList[indexPath.row]
        var textLabel = cell.viewWithTag(1) as! UILabel
        textLabel.text = data.name
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        var currACategory = self.aCategoryList[indexPath.row]
        self.currACategoryList = currACategory.subCategoryList!
        self.BCategoryCollectionView.reloadData()
    }
    
    //＝＝＝＝B分类
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.currACategoryList.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier("BCategoryCellID", forIndexPath: indexPath) as! CategoryCollectionViewCell
        var data = self.currACategoryList[indexPath.row]
        cell.categoryLabel.text = data.name
        var imgurl = NSURL(string: data.cover!)
        cell.imageView?.sd_setImageWithURL(imgurl, placeholderImage: UIImage(named: "defx.png"), options: SDWebImageOptions.ContinueInBackground, progress: { (a:Int, b:Int) -> Void in
            //println("image pross=\(a/b)")
            }, completed: { (image:UIImage!, error:NSError!, cacheType:SDImageCacheType, imgurl:NSURL!) -> Void in
                //println("cached finished")
        })
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        var subCategory:CategorySub = self.currACategoryList[indexPath.row]
        //performSegueWithIdentifier(identifier: String?, sender: AnyObject?)
        self.performSegueWithIdentifier("SubGategoryAlbumList", sender: subCategory)
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if sender?.isKindOfClass(CategorySub) == true {
            var adController:subCategoryAlbumListViewController = segue.destinationViewController as! subCategoryAlbumListViewController
            adController.subCategory = sender as? CategorySub
        }
    }

}
