//
//  HtppManagementViewController.swift
//  CoolXuePlayer
//
//  Created by lion-mac on 15/6/4.
//  Copyright (c) 2015年 lion-mac. All rights reserved.
//

import UIKit

class HttpManagement:NSObject,NSURLConnectionDataDelegate {
    var response:NSHTTPURLResponse?
    var data:NSMutableData = NSMutableData()
    func connection(connection: NSURLConnection, didSendBodyData bytesWritten: Int, totalBytesWritten: Int, totalBytesExpectedToWrite: Int) {
        println("didSendBodyData")
    }
    func connection(connection: NSURLConnection, didFailWithError error: NSError) {
        println("didFailWithError")
    }
    func connection(connection: NSURLConnection, didReceiveData data: NSData) {
        println("didReceiveData")
        self.data.appendData(data)
    }
    func connection(connection: NSURLConnection, didReceiveResponse response: NSURLResponse) {
        println("didReceiveResponse")
        self.response = response as? NSHTTPURLResponse
    }
    func connectionDidFinishLoading(connection: NSURLConnection) {
        println("connectionDidFinishLoading")
        //println("self.data=\n\(NSString(data: self.data,encoding: NSUTF8StringEncoding))")
        //println("self.response=\n\(self.response)")
    }
    func requestttt2(url:String,method:String,bodyParam:Dictionary<String,AnyObject>!,headParam:Dictionary<String,String>!,callBack:(NSHTTPURLResponse,NSData)->Void){
        println("http request:\n\(url)")
        var request = NSMutableURLRequest()
        request.timeoutInterval = 15
        request.URL = NSURL(string: url)
        if method == "POST" {
            request.HTTPMethod = method
            if bodyParam != nil {
                var paramArray:Array<String> = []
                for (key,value) in bodyParam{
                    paramArray.append("\(key)=\(value)")
                }
                var paramStr = join("&", paramArray)
                println("postparam = \(paramStr)")
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
        var conn = NSURLConnection(request: request, delegate: self)
        conn?.start()
    }
    
    static func requestttt(url:String,method:String,bodyParam:Dictionary<String,AnyObject>!,headParam:Dictionary<String,String>!,callBack:(NSHTTPURLResponse,NSData)->Void){
        println("http request:\n\(url)")
        var request = NSMutableURLRequest()
        request.timeoutInterval = 15
        request.URL = NSURL(string: url)
        if method == "POST" {
            request.HTTPMethod = method
            if bodyParam != nil {
                var paramArray:Array<String> = []
                for (key,value) in bodyParam{
                    paramArray.append("\(key)=\(value)")
                }
                var paramStr = join("&", paramArray)
                println("postparam = \(paramStr)")
                //paramStr:NSString = "password=123456&username=2794129697@qq.com"
                var bodyData:NSData = paramStr.dataUsingEncoding(NSUTF8StringEncoding)!
                request.HTTPBody = bodyData
            }
        }else{
            request.HTTPMethod = "GET"
        }
        
//        var cookieProperties:NSMutableDictionary = NSMutableDictionary()
//        cookieProperties.setValue("JSESSIONID2",forKey:NSHTTPCookieName)
//        cookieProperties.setValue("c87d9f53-f59b-4c98-82c1-71e4b7d57804",forKey:NSHTTPCookieValue)
//        cookieProperties.setValue("NSHTTPCookieDiscard",forKey:NSHTTPCookieDomain)
//        
//        var date:NSDate = NSDate()
//        date.dateByAddingTimeInterval(date.timeIntervalSinceNow)
//        cookieProperties.setValue(date ,forKey:NSHTTPCookieExpires)
//        cookieProperties.setValue("/",forKey:NSHTTPCookiePath)
//        var nsnewcookie:NSHTTPCookie =  NSHTTPCookie(properties: cookieProperties as [NSObject : AnyObject])!
//        //NSHTTPCookieStorage.setValue("asdfadsf", forKey: NSHTTPCookieName)
//        
//        var cookies:NSHTTPCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
//        cookies.setCookie(nsnewcookie)
//        println(cookies.cookies?.count)
//        println(cookies.cookies)
//        if cookies.cookies?.count > 0 {
//            var cookie = cookies.cookies?.first as! NSHTTPCookie
//            println(cookie.sessionOnly)
//            println(cookie.name)
//        }
       
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
            println("\nhttp response:\(response != nil ? response.URL : nil)")
            if response != nil {
                var httpResponse:NSHTTPURLResponse = response! as! NSHTTPURLResponse
                println("http error=\(error)")
                println("http statusCode=\(httpResponse.statusCode)")
                if httpResponse.statusCode == 200 {
                    callBack(httpResponse,data)
                }else{
                    var alert:UIAlertView = UIAlertView(title: "提示", message: "获取数据失败！", delegate: self, cancelButtonTitle: "确定")
                    alert.show()
                    println("response=\(response)")
                    var str = NSString(data: data, encoding:NSUTF8StringEncoding)
                    println("data =\(data)")
                }
            }else{
                var alert:UIAlertView = UIAlertView(title: "提示", message: "获取数据失败！", delegate: self, cancelButtonTitle: "确定")
                alert.show()
                println("error = \(error)")
                if data != nil {
                    var str = NSString(data: data, encoding:NSUTF8StringEncoding)
                    println("data =\(data)")
                }
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


    class func HttpResponseCodeCheck(code:Int,viewController:UIViewController?)->Bool{
        
        
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
                if viewController != nil {
                    viewController!.performSegueWithIdentifier("VedioViewToLogin", sender: nil)
                }
                return false
            case 700:
                return false
            default:
                return false
        }
    }
}
