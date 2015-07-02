//
//  HtppManagementViewController.swift
//  CoolXuePlayer
//
//  Created by lion-mac on 15/6/4.
//  Copyright (c) 2015年 lion-mac. All rights reserved.
//

import UIKit

class HttpManagement {
    static var request:NSMutableURLRequest = NSMutableURLRequest()
    static func requestttt(url:String,method:String,bodyParam:Dictionary<String,AnyObject>!,headParam:Dictionary<String,String>!,callBack:(NSHTTPURLResponse,NSData)->Void){
        println("http request:\(url)")
        request = NSMutableURLRequest()
        request.URL = NSURL(string: url)
        if method == "POST" {
            request.HTTPMethod = method
            if bodyParam != nil {
                var paramArray:Array<String> = []
                for (key,value) in bodyParam{
                    paramArray.append("\(key)=\(value)")
                }
                var paramStr = join("&", paramArray)
                println(paramStr)
                //paramStr:NSString = "password=123456&username=2794129697@qq.com"
                var bodyData:NSData = paramStr.dataUsingEncoding(NSUTF8StringEncoding)!
                request.HTTPBody = bodyData
            }
        }else{
            request.HTTPMethod = "GET"
        }
        if headParam != nil {
            for (key,value) in headParam{
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
//        var charset = CFStringConvertEncodingToIANACharSetName(CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
//        if request.valueForHTTPHeaderField("Content-Type") == nil {
//            request.setValue("application/x-www-form-urlencoded; charset=\(charset)",forHTTPHeaderField:"Content-Type")
//        }

        
        NSURLConnection.sendAsynchronousRequest(request, queue:  NSOperationQueue.mainQueue()) { (response:NSURLResponse!, data:NSData!, error:NSError!) -> Void in
            println("http response-----------------------")
            if response != nil {
                var httpResponse:NSHTTPURLResponse = response! as! NSHTTPURLResponse
                if httpResponse.statusCode != 200 {
                    var alert:UIAlertView = UIAlertView(title: "提示", message: "获取数据失败！", delegate: self, cancelButtonTitle: "确定")
                    alert.show()
                    println("error=\(error)\nhttpResponse.statusCode=\(httpResponse.statusCode)")
                    println("response=\(response)")
                    var str = NSString(data: data, encoding:NSUTF8StringEncoding)
                    println("data =\(data)")
                }else{
                    callBack(httpResponse,data)
                }
            }else{
                var httpResponse:NSHTTPURLResponse = response! as! NSHTTPURLResponse
                var alert:UIAlertView = UIAlertView(title: "提示", message: "获取数据失败！", delegate: self, cancelButtonTitle: "确定")
                alert.show()
                println("error=\(error)\nhttpResponse.statusCode=\(httpResponse.statusCode)")
                println("response=\(response)")
                var str = NSString(data: data, encoding:NSUTF8StringEncoding)
                println("data =\(data)")
            }
        }
        
//        NSURLConnection.sendAsynchronousRequest(
//            request, queue: NSOperationQueue.mainQueue()) { (response:NSURLResponse!, data:NSData!, error:NSError!) -> Void in
//                //println("responseerror=\(error)")
//                var httpResponse = response as! NSHTTPURLResponse
//                var str = NSString(data: data, encoding:NSUTF8StringEncoding)
//                //println("str =\(str)")
//                //println()
//                if httpResponse.statusCode == 200 {
//                    var bdict:NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: nil) as!NSDictionary
//                    println(bdict)
//                }
//        }
        
    }


    class func HttpResponseCodeCheck(code:Int,viewController:UIViewController)->Bool{
        
        
//        100：表明用户需要充值才能继续使用。
//        200：表明该操作成功。
//        400：表明该操作失败。
//        500：服务器错误。
//        600：表明该操作需要登录（弹出登录框）。
//        700：该功能已经被禁用。
        
        var alert:UIAlertView?
        switch code{
            case 100:
                var alert:UIAlertView = UIAlertView(title: "提示", message: "亲，你未购买此视频教程！", delegate: self, cancelButtonTitle: "确定")
                alert.show()
                return false
            case 200:
                return true
            case 400:
                return false
            case 500:
                return false
            case 600:
                var alert:UIAlertView = UIAlertView(title: "提示", message: "亲，请登录！", delegate: self, cancelButtonTitle: "确定")
                alert.show()
                viewController.performSegueWithIdentifier("VedioViewToLogin", sender: nil)
                return false
            case 700:
                return false
            default:
                return false
        }
    }
}
