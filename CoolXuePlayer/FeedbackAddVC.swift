//
//  FeedbackAddVC.swift
//  CoolXuePlayer
//
//  Created by lion-mac on 15/7/23.
//  Copyright (c) 2015年 lion-mac. All rights reserved.
//

import UIKit

class FeedbackAddVC: UIViewController {
    @IBOutlet weak var contentTextView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func bnSubmitFeedback(sender: AnyObject) {
       var content = contentTextView.text
        if content.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) < 5 {
            self.showNoticeText("不能少于5个字")
            return
        }
        self.addFeedback(content)
    }
    
    func addFeedback(content:String){
        var url = "http://www.icoolxue.com/feedback"
        var param = ["content":content]
        HttpManagement.requestttt(url, method: "POST", bodyParam: param, headParam: nil) { (reponse, data) -> Void in
            var dict:NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: nil) as! NSDictionary
            var code:Int = dict["code"] as! Int
            if HttpManagement.HttpResponseCodeCheck(code, viewController: self){
                self.navigationController?.popViewControllerAnimated(true)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
