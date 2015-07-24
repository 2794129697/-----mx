//
//  VedioPlayerViewController.swift
//  CoolXuePlayer
//
//  Created by lion-mac on 15/6/3.
//  Copyright (c) 2015年 lion-mac. All rights reserved.
//

import UIKit
import AVFoundation

class VedioPlayerViewController: UIViewController,VedioDescTVDelegate {
    var channel:Vedio?
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
    @IBOutlet weak var progressView: UIView!
    var timer:NSTimer?
    @IBOutlet weak var bnOp: UIButton!
    @IBOutlet weak var descTBView: VedioDescTV!
    var is_bar_show:Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationController?.hidesBarsOnTap = true
        IS_AUTOROTATE = true
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.Plain, target: self, action: "fnNavBackClicked")
        //其它页面刷新本页面的通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "ReceivedNotif:", name: "ReloadView", object: nil)
        
        viewForPlayerLayer.clipsToBounds = true
        viewForPlayerLayer.layer.addSublayer(playerLayer);
        self.descTBView.gotoViewDelegate = self
        self.initVedio()
    }
    
    func initVedio(){
        //播放
        self.playByItem(self.channel!.vedioUrl)
        //self.playByItem("http://static.tripbe.com/videofiles/20121214/9533522808.f4v.mp4")
        //显示视频详情
        self.descTBView.showVedioDetailInfo(self.channel!)
    }
    
    func ReceivedNotif(obj:NSNotification){
        var vedio:Vedio! = obj.object as! Vedio
        if vedio != nil {
            self.channel = vedio
            self.initVedio()
        }
    }
    
    func turnToVedioListView(vedio: Vedio) {
        self.performSegueWithIdentifier("ToVedioListVC", sender: vedio)
    }
    
    //页面上的元件重新布局后，会调用(目前还没有找到对某个元件的frame/bounds发生变化时的通知)
    override func viewDidLayoutSubviews() {
        playerLayer.frame = viewForPlayerLayer.bounds
    }
    
    func fnNavBackClicked(){
        if UIDevice.currentDevice().orientation == UIDeviceOrientation.LandscapeLeft {
            UIDevice.currentDevice().setValue(UIDeviceOrientation.LandscapeLeft.rawValue, forKey: "orientation")
            UIDevice.currentDevice().setValue(UIDeviceOrientation.Portrait.rawValue, forKey: "orientation")
        }else{
            self.navigationController?.popViewControllerAnimated(true)
        }
    }

    func playByItem(url:String){
        println("vedio_url=\n\(url)")
        D3Notice.wait(D3Notice.longTime,autoClear: false)
        self.bnPlay.enabled = false
        //url = NSBundle.mainBundle().URLForResource("story", withExtension: "mp4")
        self.releaseAVPlayer()
        var nurl = NSURL(string:url)
        nurl?.setResourceValues(["referer":"http://www.icoolxue.com"], error: nil)
        currplayeritem = AVPlayerItem(URL: nurl)
        myplayer = AVPlayer(playerItem: currplayeritem)
        playerLayer.player = myplayer
        //myplayer?.volume = 0
        
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
                D3Notice.clearWait()
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
                D3Notice.clearWait()
                self.showNoticeText("视频播放失败！")
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
    @IBAction func bnShowOrHideBar(sender: UIButton) {
        var orientation = UIDevice.currentDevice().orientation
        if (orientation == UIDeviceOrientation.LandscapeLeft || orientation == UIDeviceOrientation.LandscapeRight){
            if self.is_bar_show {
                self.is_bar_show = false
                self.navigationController?.setNavigationBarHidden(true, animated: true)
                self.progressView.hidden = true
            }else{
                self.is_bar_show = true
                self.navigationController?.setNavigationBarHidden(false, animated: true)
                self.progressView.hidden = false
            }
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
    
    override func willAnimateRotationToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        //println("willAnimateRotationToInterfaceOrientation")
        if (toInterfaceOrientation == UIInterfaceOrientation.Portrait || toInterfaceOrientation == UIInterfaceOrientation.PortraitUpsideDown){
            self.bnFullScreen.setImage(UIImage(named: "videoFullScreenNomal"), forState: UIControlState.Normal)
            self.is_bar_show = true
            self.navigationController?.setNavigationBarHidden(false, animated: true)
            self.progressView.hidden = false
        }else{
            self.bnFullScreen.setImage(UIImage(named: "videoUnFullScreenNomal"), forState: UIControlState.Normal)
            self.bnShowOrHideBar(self.bnOp)
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
    
    func releaseAVPlayer(){
        if playerLayer.player != nil {
            if playerLayer.player.status == AVPlayerStatus.ReadyToPlay {
                playerLayer.player.pause()
            }
            self.currplayeritem!.removeObserver(self, forKeyPath: "status")
            self.currplayeritem!.removeObserver(self, forKeyPath: "loadedTimeRanges")
            //移除时不确定是否注册了该观察者（目前没有找到判断的方法）
            //NSNotificationCenter.defaultCenter().removeObserver(self, forKeyPath: "AVPlayerItemDidPlayToEndTimeNotification")
        }
    }
    
    override func viewDidDisappear(animated: Bool) {
        self.releaseAVPlayer()
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier! == "ToVedioListVC" {
            if sender?.isKindOfClass(Vedio) == true {
                var adController:VedioListVC = segue.destinationViewController as! VedioListVC
                adController.channel = sender as? Vedio
            }
        }
    }
}