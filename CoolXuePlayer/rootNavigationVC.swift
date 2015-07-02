//
//  rootNavigationVC.swift
//  CoolXuePlayer
//
//  Created by lion-mac on 15/6/30.
//  Copyright (c) 2015年 lion-mac. All rights reserved.
//

import UIKit
//是否允许自动旋转屏幕内容
var IS_AUTOROTATE = false
class rootNavigationVC: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func shouldAutorotate() -> Bool {
        return IS_AUTOROTATE
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
