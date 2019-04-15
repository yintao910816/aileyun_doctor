//
//  ShowVideoViewController.swift
//  pregnancyForD
//
//  Created by huchuang on 2018/6/14.
//  Copyright © 2018年 pg. All rights reserved.
//

import UIKit
import AVFoundation

import SVProgressHUD

//AVPlayerItem：一个媒体资源管理对象，管理者视频的一些基本信息和状态，一个AVPlayerItem对应着一个视频资源。
class ShowVideoViewController: UIViewController {
    
    lazy var playerView : HCPlayerView = {
        let p = HCPlayerView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_WIDTH))
        return p
    }()
    
    var playerItem : AVPlayerItem!
    var avplayer : AVPlayer!
    var playerLayer : AVPlayerLayer!
    
    var link : CADisplayLink!
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        get {
            return .lightContent
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "视频播放"
        
        // 检测连接是否存在 不存在报错
        //http://file.ivfcn.com/common-file/app/img/Embroy/video/10/10.avi
        guard let url = URL.init(string: "http://file.ivfcn.com/common-file/app/img/Embroy/video/1/1.mp4") else {
            fatalError("url连接错误")
        }
        
        
        //测试
//        let filePath = Bundle.main.path(forResource: "1", ofType: "mp4")
//        let url = URL(fileURLWithPath: filePath!)
        
        
        
        playerItem = AVPlayerItem.init(url: url) // 创建视频资源
        
        // 监听缓冲进度改变
        playerItem.addObserver(self, forKeyPath: "loadedTimeRanges", options: NSKeyValueObservingOptions.new, context: nil)
        // 监听状态改变
        playerItem.addObserver(self, forKeyPath: "status", options: NSKeyValueObservingOptions.new, context: nil)
        // 缓冲不足
        playerItem.addObserver(self, forKeyPath: "playbackBufferEmpty", options: NSKeyValueObservingOptions.new, context: nil)
        // 缓冲足够播放
        playerItem.addObserver(self, forKeyPath: "playbackLikelyToKeepUp", options: NSKeyValueObservingOptions.new, context: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ShowVideoViewController.playVideoEnd), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerItem)
        
        avplayer = AVPlayer(playerItem: playerItem)
        playerLayer = AVPlayerLayer(player: avplayer)
        //设置模式
        playerLayer.videoGravity = AVLayerVideoGravityResizeAspect
        playerLayer.contentsScale = UIScreen.main.scale
        
        self.view.addSubview(self.playerView)
        
        
        self.playerView.playerLayer = self.playerLayer
        self.playerView.layer.insertSublayer(playerLayer, at: 0)
        
        self.playerView.delegate = self
        
        self.link = CADisplayLink(target: self, selector: #selector(ShowVideoViewController.update))
        self.link.add(to: RunLoop.main, forMode: RunLoopMode.defaultRunLoopMode)
        
        SVProgressHUD.show()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func playVideoEnd(){
        HCPrint(message: "播放完毕")
        self.playerView.playBtn.setImage(UIImage(named: "player_play"), for: UIControlState.normal)
        self.playerView.playing = false
        let seekTime = CMTimeMake(0, 1)
        self.avplayer.seek(to: seekTime, completionHandler: {b in
            
        })
    }
    
    
    deinit{
        playerItem.removeObserver(self, forKeyPath: "loadedTimeRanges")
        playerItem.removeObserver(self, forKeyPath: "status")
        playerItem.removeObserver(self, forKeyPath: "playbackBufferEmpty")
        playerItem.removeObserver(self, forKeyPath: "playbackLikelyToKeepUp")
        
        NotificationCenter.default.removeObserver(self)
    }
    
    
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let playerItem = object as? AVPlayerItem else { return }
        if keyPath == "loadedTimeRanges"{
            //通过监听AVPlayerItem的"loadedTimeRanges"，可以实时知道当前视频的进度缓冲
            HCPrint(message: "获取缓冲进度")
            let loadedTime = avalableDurationWithplayerItem()
            let totalTime = CMTimeGetSeconds(playerItem.duration)
            let percent = loadedTime/totalTime
            
            self.playerView.progressView.progress = Float(percent)
        }else if keyPath == "status"{
            
            SVProgressHUD.dismiss()
            
            if playerItem.status == AVPlayerItemStatus.readyToPlay{
                HCPrint(message: "readyToPlay")
                // 只有在这个状态下才能播放
                self.avplayer.play()
            }else{
                HCPrint(message: "加载失败 pause")
            }
        }else if keyPath == "playbackBufferEmpty"{
            HCPrint(message: "缓冲不足  播放暂停")
            SVProgressHUD.show()
        }else if keyPath == "playbackLikelyToKeepUp" {
            HCPrint(message: "缓冲充足 可以播放")
            SVProgressHUD.dismiss()
        }
    }
    
    
    func avalableDurationWithplayerItem()->TimeInterval{
        guard let loadedTimeRanges = avplayer?.currentItem?.loadedTimeRanges, let first = loadedTimeRanges.first else {
            fatalError("获取进度信息失败")
        }
        let timeRange = first.timeRangeValue
        let startSeconds = CMTimeGetSeconds(timeRange.start)
        let durationSecound = CMTimeGetSeconds(timeRange.duration)
        let result = startSeconds + durationSecound
        return result
    }
    
    //更新时间
    func update(){
        //暂停的时候
        if !self.playerView.playing{
            return
        }
        
        let currentTime = CMTimeGetSeconds(self.avplayer.currentTime())
        let totalTime   = TimeInterval(playerItem.duration.value) / TimeInterval(playerItem.duration.timescale)
        
        let timeStr = "\(formatPlayTime(secounds: currentTime))/\(formatPlayTime(secounds: totalTime))"
        playerView.timeLabel.text = timeStr
        
//        if currentTime == totalTime{
//            avplayer.pause()
//            playVideoEnd()
//        }
        
        // 判断有没有在滑动
        if !self.playerView.sliding{
            // 修改播放进度
            self.playerView.slider.value = Float(currentTime/totalTime)
        }
    }
    
    
    func formatPlayTime(secounds: TimeInterval)->String{
        if secounds.isNaN{
            return "00:00"
        }
        let i = Int(secounds)
        let Min = Int(i / 60)
        let Sec = Int(i % 60)
        return String(format: "%02d:%02d", Min, Sec)
    }
    
}

extension ShowVideoViewController: HCPlayerViewDelegate{
    // 滑动滑块 指定播放位置
    func zzplayer(playerView: HCPlayerView, sliderTouchUpOut slider: UISlider) {
        
        //当视频状态为AVPlayerStatusReadyToPlay时才处理
        if self.avplayer.status == AVPlayerStatus.readyToPlay{
            let duration = slider.value * Float(CMTimeGetSeconds(self.avplayer.currentItem!.duration))
            let seekTime = CMTimeMake(Int64(duration), 1)
            self.avplayer.seek(to: seekTime, completionHandler: { [weak self](b) in
                self?.playerView.sliding = false
            })
        }
    }
    
    
    func zzplayer(playerView: HCPlayerView, playAndPause playBtn: UIButton) {
        if !playerView.playing{
            self.avplayer.pause()
        }else{
            if self.avplayer.status == AVPlayerStatus.readyToPlay{
                self.avplayer.play()
            }
        }
    }
    
}

