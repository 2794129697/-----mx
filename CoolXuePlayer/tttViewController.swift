//
//  tttViewController.swift
//  CoolXuePlayer
//
//  Created by lion-mac on 15/5/29.
//  Copyright (c) 2015年 lion-mac. All rights reserved.
//

import UIKit

class tttViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var channelTableView: UITableView!
    @IBOutlet weak var topscview: UIScrollView!
    @IBOutlet weak var ssview: UIScrollView!
    var xxsize:CGSize!
    
    func addFrame(){
        var view1:UIView  = UIView(frame: CGRectMake(20, 20, 280, 250));
        view1.bounds = CGRectMake(-20, -20, 280, 250);
        view1.backgroundColor = UIColor.redColor()
        self.view.addSubview(view1);//添加到self.view
        //NSLog(@"view1 frame:%@========view1 bounds:%@",NSStringFromCGRect(view1.frame),NSStringFromCGRect(view1.bounds));
        
        var view2:UIView = UIView(frame:CGRectMake(0, 0, 100, 100));
        view2.backgroundColor = UIColor.yellowColor()
        view1.addSubview(view2);//添加到view1上,[此时view1坐标系左上角起点为(-20,-20)]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //addFrame()
        
        self.ssview.contentSize = CGSize(width: 320, height: 440)
        self.topscview.contentSize = CGSize(width: 500, height: 50)
        self.channelTableView.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.New, context: nil)
        // Do any additional setup after loading the view.
    }
    
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        if keyPath == "contentSize" {
            var frame = self.channelTableView.frame;
//            frame.size = self.channelTableView.contentSize;
//            self.channelTableView.frame = frame;

            
            
//           println("object.contentSize\(object.contentSize)")
//            println("change\(change)")
            println(self.channelTableView.bounds)
            println("frame=\(frame)\n")
//            println("frame.size\(frame.size)\n")
            //println(self.channelTableView.contentSize)
            //设置了frame.size后frame.y要变化，搞不懂啊
            //self.channelTableView.frame.size = self.channelTableView.contentSize
            
            
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
        return 10
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("celll", forIndexPath: indexPath) as! UITableViewCell
        cell.textLabel?.text = "ab"+String(indexPath.row)
        println(indexPath.row)
        //tableView.frame.size = xxsize
        return cell
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
