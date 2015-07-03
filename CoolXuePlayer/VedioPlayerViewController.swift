//
//  VedioPlayerViewController.swift
//  CoolXuePlayer
//
//  Created by lion-mac on 15/6/3.
//  Copyright (c) 2015年 lion-mac. All rights reserved.
//

import UIKit
import AVFoundation

class VedioPlayerViewController: UIViewController {
    var channel:Channel?
    //当前播放时间
    @IBOutlet weak var currplayTimeLabel: UILabel!
    //总时间
    @IBOutlet weak var totalTimeLabel: UILabel!
    //缓冲进度
    @IBOutlet weak var downprogressView: UIProgressView!
    //播放进度
    @IBOutlet weak var playSlider: UISlider!
    @IBOutlet weak var bnPlay: UIButton!
    @IBOutlet weak var bnFullScreen: UIButton!
    //视频播放
    let playerLayer:AVPlayerLayer = AVPlayerLayer()
    var myplayer:AVPlayer?
    var currplayeritem:AVPlayerItem?
    //缓冲进度
    var currDownPross:Float?
    @IBOutlet weak var viewForPlayerLayer: UIView!
    var timer:NSTimer?
    
    var start_frame:CGRect!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bnPlay.enabled = false
        //self.navigationController?.hidesBarsOnTap = true
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.Plain, target: self, action: "fnNavBackClicked")
        IS_AUTOROTATE = true
        viewForPlayerLayer.clipsToBounds = true
        start_frame = viewForPlayerLayer.frame
        
        
        playerLayer.frame = viewForPlayerLayer.bounds
        println(viewForPlayerLayer.frame)
        println(viewForPlayerLayer.bounds)
        viewForPlayerLayer.layer.addSublayer(playerLayer);
        //self.playByItem(self.channel!.vedioUrl)
        self.playByItem("http://static.tripbe.com/videofiles/20121214/9533522808.f4v.mp4")
    }
    
    func fnNavBackClicked(){
        println("xx")
        if UIDevice.currentDevice().orientation == UIDeviceOrientation.LandscapeLeft {
            UIDevice.currentDevice().setValue(UIDeviceOrientation.LandscapeLeft.rawValue, forKey: "orientation")
            UIDevice.currentDevice().setValue(UIDeviceOrientation.Portrait.rawValue, forKey: "orientation")
        }else{
            self.navigationController?.popToRootViewControllerAnimated(true)
        }
    }
    
    @IBAction func bnPlayClicked(sender: UIButton) {
        if playerLayer.player != nil {
            if playerLayer.player.status != AVPlayerStatus.ReadyToPlay {
                return
            }
        }else{
            return
        }
        if playerLayer.player != nil {
            if sender.selected {
                bnPlay.setImage(UIImage(named: "videoPlayNomal"), forState: UIControlState.Normal)
                playerLayer.player.pause()
            }else{
                bnPlay.setImage(UIImage(named: "videoPauseNomal"), forState: UIControlState.Normal)
                playerLayer.player.play()
            }
        }
        sender.selected = !sender.selected
    }
    
    @IBAction func playSliderValueChange(sender: UISlider) {
        if playerLayer.player != nil && playerLayer.player.status == AVPlayerStatus.ReadyToPlay {
            //拖动改变视频播放进度
            
            //计算出拖动的当前秒数
            //NSInteger dragedSeconds = floorf(totalMovieDuration*movieProgressSlider.value);
            var dragedSeconds = CMTimeGetSeconds(self.playerLayer.player.currentItem.duration) * Float64(sender.value)
            //println("dragedSeconds:\(dragedSeconds)");
            
            //转换成CMTime才能给player来控制播放进度
            var dragedCMTime:CMTime = CMTimeMakeWithSeconds(dragedSeconds,1)
            //var dragedCMTime:CMTime = CMTimeMake(Int64(dragedSeconds), 1)
            //[moviePlayeView.playerpause];
            self.playerLayer.player.pause()
            //[moviePlayeView.player seekToTime:dragedCMTime completionHandler:^(BOOL finish){
            self.playerLayer.player.seekToTime(dragedCMTime)
            //[moviePlayeView.playerplay];
            self.playerLayer.player.play()
        }
    }
    
    func playByItem(url:String){
        println("vedio_url=ln\(url)")
        //url = NSBundle.mainBundle().URLForResource("story", withExtension: "mp4")
        currplayeritem = AVPlayerItem(URL: NSURL(string:url))
        myplayer = AVPlayer(playerItem: currplayeritem)
        playerLayer.player = myplayer
        
        currplayeritem!.addObserver(self, forKeyPath: "status", options: NSKeyValueObservingOptions.Old, context: nil)
        currplayeritem!.addObserver(self, forKeyPath: "loadedTimeRanges", options: NSKeyValueObservingOptions.New, context: nil)
        
        //        NSURL *videoUrl = [NSURL URLWithString:@"http://www.jxvdy.com/file/upload/201405/05/18-24-58-42-627.mp4"];
        //        self.playerItem = [AVPlayerItem playerItemWithURL:videoUrl];
        //        [self.playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];// 监听status属性
        //        [self.playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];// 监听loadedTimeRanges属性
        //        self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
        //        [[NSNotificationCenterdefaultCenter]addObserver:selfselector:@selector(moviePlayDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotificationobject:self.playerItem];
    }
    
    func playbackFinished(){
        println("playFinish!")
    }
    
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        var tempplayerItem = object as! AVPlayerItem
        if keyPath == "loadedTimeRanges" {
            //println("-------------loadedTimeRanges\n\(object)\n\(change)\n\(context)")
            
            //NSArray *loadedTimeRanges = [[self.playerView.player currentItem] loadedTimeRanges];
            var loadedTimeRanges:Array = tempplayerItem.loadedTimeRanges
            //CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];// 获取缓冲区域
            var timeRange:CMTimeRange = loadedTimeRanges.first!.CMTimeRangeValue
            
            var startSeconds:Float64 = CMTimeGetSeconds(timeRange.start);
            var durationSeconds:Float64 = CMTimeGetSeconds(timeRange.duration);
            
            //println("startSeconds=\(startSeconds) durationSeconds=\(durationSeconds)")
            var currdownDuration:NSTimeInterval = startSeconds + durationSeconds;// 计算缓冲总进度
            
            var totalDuration:Float64 = CMTimeGetSeconds(tempplayerItem.duration);
            //println("loadedTimeRanges currdownDuration=\(currdownDuration)totalDuration=\(totalDuration)")
            //显示缓冲进度
            self.currDownPross = Float(currdownDuration / totalDuration)
            self.downprogressView.setProgress(self.currDownPross!, animated: true)
        }else if keyPath == "status"{
            println("-------------status")
            if tempplayerItem.status == AVPlayerItemStatus.ReadyToPlay {
                println("play")
                playerLayer.player.play()
                self.bnPlay.enabled = true
                bnPlay.setImage(UIImage(named: "videoPauseNomal"), forState: UIControlState.Normal)
                //播放结束
                NSNotificationCenter.defaultCenter().addObserver(self, selector: "playbackFinished", name: "AVPlayerItemDidPlayToEndTimeNotification", object: self.playerLayer.player.currentItem)

                //CMTime duration = self.playerItem.duration;// 获取视频总长度
                var duration = tempplayerItem.duration
                // CGFloat totalSecond = playerItem.duration.value / playerItem.duration.timescale;// 转换成秒
                var totalSecond = Float(duration.value)/Float(duration.timescale)
                var showtotalTime:String = self.convertTime(NSTimeInterval(totalSecond))
                self.totalTimeLabel.text = showtotalTime
                
                //monitoringPlayback用于监听每秒的状态，- (id)addPeriodicTimeObserverForInterval:(CMTime)interval queue:(dispatch_queue_t)queue usingBlock:(void (^)(CMTime time))block;此方法就是关键，interval参数为响应的间隔时间，这里设为每秒都响应，queue是队列，传NULL代表在主线程执行。可以更新一个UI，比如进度条的当前时间等。
                playerLayer.player.addPeriodicTimeObserverForInterval(CMTimeMake(1, 1), queue: nil, usingBlock: { (currplaytime:CMTime) -> Void in
                    //println("addPeriodicTimeObserverForInterval")
                    self.updateVideoSlider()
                })
            } else if tempplayerItem.status == AVPlayerItemStatus.Failed {
                println("AVPlayerStatusFailed")
            }
        }
    }
    
    func updateVideoSlider(){
        //CGFloat currentSecond = playerItem.currentTime.value/playerItem.currentTime.timescale;// 计算当前在第几秒
        var tempplayeritem = self.playerLayer.player.currentItem
        if tempplayeritem != nil {
            var currplayerSecond:Float = Float(tempplayeritem.currentTime().value) / Float(tempplayeritem.currentTime().timescale)
            //NSString *timeString = [self convertTime:currentSecond];
            var showcurrTime:String = self.convertTime(NSTimeInterval(currplayerSecond))
            
            var duration = tempplayeritem.duration
            // CGFloat totalSecond = playerItem.duration.value / playerItem.duration.timescale;// 转换成秒
            var totalplayerSecond = Float(duration.value)/Float(duration.timescale)
            
            self.currplayTimeLabel.text = showcurrTime
            self.playSlider.value = currplayerSecond/totalplayerSecond
            //println("currplayerSecond = \(currplayerSecond) totalplayerSecond=\(totalplayerSecond)")
        }
    }
    
    func convertTime(second:NSTimeInterval)->String{
        //println("convertTime time =\(second)")
        var d:NSDate = NSDate(timeIntervalSince1970: second)
        var formatter:NSDateFormatter = NSDateFormatter()
        if (second/3600 >= 1) {
            formatter.dateFormat = "HH:mm:ss"
        } else {
            formatter.dateFormat = "mm:ss"
        }
        //NSString *showtimeNew = [formatter stringFromDate:d];
        var showtimeNew = formatter.stringFromDate(d)
        
        return showtimeNew;
    }
    
    @IBAction func bnfullScreenClicked(sender: AnyObject) {
        println("bnfullScreenClicked")
        if UIDevice.currentDevice().respondsToSelector(Selector("setOrientation:")) {
            //是否是横屏
            if UIDevice.currentDevice().orientation != UIDeviceOrientation.LandscapeLeft {
               //UIDevice.currentDevice().setValue(UIDeviceOrientation.Portrait.rawValue, forKey: "orientation")
                UIDevice.currentDevice().setValue(UIDeviceOrientation.LandscapeLeft.rawValue, forKey: "orientation")
            }else{
                //UIDevice.currentDevice().setValue(UIDeviceOrientation.LandscapeLeft.rawValue, forKey: "orientation")
                UIDevice.currentDevice().setValue(UIDeviceOrientation.Portrait.rawValue, forKey: "orientation")
            }
        }
    }
    
    override func willAnimateRotationToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        println("willAnimateRotationToInterfaceOrientation")
        //self.playerLayer.frame = self.viewForPlayerLayer.bounds
//        if (toInterfaceOrientation == UIInterfaceOrientation.Portrait || toInterfaceOrientation == UIInterfaceOrientation.PortraitUpsideDown){
//            viewForPlayerLayer.frame = start_frame
//            playerLayer.frame = viewForPlayerLayer.bounds
//        }else{
//            viewForPlayerLayer.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.width,UIScreen.mainScreen().bounds.height)
//            playerLayer.frame = viewForPlayerLayer.bounds
//        }
        if (toInterfaceOrientation == UIInterfaceOrientation.Portrait || toInterfaceOrientation == UIInterfaceOrientation.PortraitUpsideDown){
            self.bnFullScreen.setImage(UIImage(named: "videoFullScreenNomal"), forState: UIControlState.Normal)
        }else{
            self.bnFullScreen.setImage(UIImage(named: "videoUnFullScreenNomal"), forState: UIControlState.Normal)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        println("didReceiveMemoryWarning")
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewDidDisappear(animated: Bool) {
        println("viewDidDisappear")
        if playerLayer.player != nil {
            if playerLayer.player.status == AVPlayerStatus.ReadyToPlay {
                playerLayer.player.pause()
            }
            playerLayer.player.currentItem.removeObserver(self, forKeyPath: "status")
            playerLayer.player.currentItem.removeObserver(self, forKeyPath: "loadedTimeRanges")
            //NSNotificationCenter.defaultCenter().removeObserver(self, forKeyPath: "AVPlayerItemDidPlayToEndTimeNotification")
        }
    }
}