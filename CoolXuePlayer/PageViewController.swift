//
//  PageViewController.swift
//  CoolXuePlayer
//
//  Created by lion-mac on 15/5/29.
//  Copyright (c) 2015年 lion-mac. All rights reserved.
//

import UIKit

class PageViewController: UIViewController,UIScrollViewDelegate {
    var pageImages: [UIImage] = []
    var pageViews: [UIImageView?] = []
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
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
            var frame = scrollView.bounds
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
            scrollView.addSubview(newPageView)
            
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

    func scrollViewDidScroll(scrollView: UIScrollView) {
        // Load the pages that are now on screen
        loadVisiblePages()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
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
        pageControl.currentPage = 0
        pageControl.numberOfPages = pageCount
        
        // 3
        for _ in 0..<pageCount {
            pageViews.append(nil)
        }
        
        // 4
        let pagesScrollViewSize = scrollView.frame.size
        scrollView.contentSize = CGSize(width: pagesScrollViewSize.width * CGFloat(pageImages.count),
            height: pagesScrollViewSize.height)
        
        // 5
        loadVisiblePages()
        // Do any additional setup after loading the view.
    }
    
    func loadVisiblePages() {
        // 首先确定当前可见的页面
        let pageWidth = scrollView.frame.size.width
        let page = Int(floor((scrollView.contentOffset.x * 2.0 + pageWidth) / (pageWidth * 2.0)))
        
        // 更新pageControl
        pageControl.currentPage = page
        
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
