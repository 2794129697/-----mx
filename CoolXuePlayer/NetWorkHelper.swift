//
//  NetWorkHelper.swift
//  CoolXuePlayer
//
//  Created by lion-mac on 15/7/24.
//  Copyright (c) 2015年 lion-mac. All rights reserved.
//

import Foundation
public class NetWorkHelper:NSObject{
    //网络状态
    public static var networkStatus:Int = 0
    //网络是否正常
    public static var is_network_ok:Bool = false
    //是否已经注册网络监测
    private static var is_register_network_monitor:Bool = false
    
    private static var hostReachability:Reachability!
    private static var internetReachability:Reachability!
    private static var wifiReachability:Reachability!
    
    private static var observer:NetWorkHelper = NetWorkHelper()
    
    private override init(){
        println("init")
    }
    
    //监测设备网络
    public class func registerNetWorkMonitor(){
        if !self.is_register_network_monitor {
            self.is_register_network_monitor = true
            NSNotificationCenter.defaultCenter().addObserver(observer, selector: "reachabilityChanged:", name: kReachabilityChangedNotification, object: nil)
            self.hostReachability = Reachability(hostName: "www.apple.com")
            self.hostReachability.startNotifier()
            self.internetReachability = Reachability.reachabilityForInternetConnection()
            self.internetReachability.startNotifier()
            
            
            self.wifiReachability = Reachability.reachabilityForLocalWiFi()
            self.wifiReachability.startNotifier()
            
            println(self.hostReachability.currentReachabilityStatus().value)
            println(self.internetReachability.currentReachabilityStatus().value)
            println(self.wifiReachability.currentReachabilityStatus().value)
            
            if self.hostReachability.currentReachabilityStatus().value != 0 || self.internetReachability.currentReachabilityStatus().value != 0 || self.wifiReachability.currentReachabilityStatus().value != 0{
                NetWorkHelper.is_network_ok = true
            }
        }
    }
    
    //设备网络环境发生变化时通知(不能写成私有方法)
    func reachabilityChanged(note:NSNotification){
        println("reachabilityChanged")
        var curReach:Reachability = note.object as! Reachability
        
        var netStatus:NetworkStatus = curReach.currentReachabilityStatus()
        var connectionRequired = curReach.connectionRequired()
        var statusString = "";
        println(netStatus.value)
        if netStatus.value == 0 {
            NetWorkHelper.is_network_ok = false
            println("没有可用网络！\(netStatus.value)")
            D3Notice.showText("没有可用网络！\(netStatus.value)",time:D3Notice.longTime,autoClear:true)
        }else{
            NetWorkHelper.is_network_ok = true
            println("网络已连接！\(netStatus.value)")
            D3Notice.showText("网络已连接！\(netStatus.value)",time:D3Notice.longTime,autoClear:true)
        }
        switch netStatus.value
        {
            case 0:
                break;
            case 1:
                break;
            case 2:
                break;
            default:
                break;
        }
        
        if (connectionRequired){
            println("%@, Connection Required"+"Concatenation of status string with connection requirement")
        }
    }
}

public enum IJReachabilityType {
    case WWAN,
    WiFi,
    NotConnected
}

public class IJReachability {
    
    /**
    :see: Original post - http://www.chrisdanielson.com/2009/07/22/iphone-network-connectivity-test-example/
    */
    public class func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(&zeroAddress) {
            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0)).takeRetainedValue()
        }
        
        var flags: SCNetworkReachabilityFlags = 0
        if SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) == 0 {
            return false
        }
        
        let isReachable = (flags & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        
        return (isReachable && !needsConnection) ? true : false
    }
    
    public class func isConnectedToNetworkOfType() -> IJReachabilityType {
        
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(&zeroAddress) {
            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0)).takeRetainedValue()
        }
        
        var flags: SCNetworkReachabilityFlags = 0
        if SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) == 0 {
            return .NotConnected
        }
        
        let isReachable = (flags & UInt32(kSCNetworkFlagsReachable)) != 0
        let isWWAN = (flags & UInt32(kSCNetworkReachabilityFlagsIsWWAN)) != 0
        //let isWifI = (flags & UInt32(kSCNetworkReachabilityFlagsReachable)) != 0
        
        if(isReachable && isWWAN){
            return .WWAN
        }
        if(isReachable && !isWWAN){
            return .WiFi
        }
        
        return .NotConnected
        //let needsConnection = (flags & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        
        //return (isReachable && !needsConnection) ? true : false
    }
    
    public class func test(){
        if IJReachability.isConnectedToNetwork() {
            println("Network Connection: Available")
        } else {
            println("Network Connection: Unavailable")
        }
        let statusType = IJReachability.isConnectedToNetworkOfType()
        switch statusType {
        case .WWAN:
            println("Connection Type: Mobile\n")
        case .WiFi:
            println("Connection Type: WiFi\n")
        case .NotConnected:
            println("Connection Type: Not connected to the Internet\n")
        }
    }
}
