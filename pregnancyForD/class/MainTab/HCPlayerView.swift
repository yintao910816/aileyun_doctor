//
//  ZZPlayerView.swift
//  ZZPlayer
//
//  Created by duzhe on 16/8/19.
//  Copyright © 2016年 dz. All rights reserved.

import UIKit
import AVFoundation

protocol HCPlayerViewDelegate:NSObjectProtocol {
    
    func zzplayer(playerView:HCPlayerView, sliderTouchUpOut slider:UISlider)
    func zzplayer(playerView:HCPlayerView, playAndPause playBtn:UIButton)
}

class HCPlayerView: UIView {
    
    var playerLayer : AVPlayerLayer?
    var slider : UISlider!
    var progressView : UIProgressView!
    var playBtn : UIButton!
    
    var timeLabel:UILabel!
    var sliding = false
    var playing = true
    
    weak var delegate : HCPlayerViewDelegate?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        slider = UISlider.init()
        self.addSubview(slider)
        slider.snp.updateConstraints { (make) in
            make.bottom.equalTo(self).inset(5)
            make.left.equalTo(self).offset(50)
            make.right.equalTo(self).inset(100)
            make.height.equalTo(15)
        }
        
        slider.minimumValue = 0
        slider.maximumValue = 1
        slider.value = 0
        // 从最大值滑向最小值时杆的颜色
        slider.maximumTrackTintColor = UIColor.clear
        // 从最小值滑向最大值时杆的颜色
        slider.minimumTrackTintColor = UIColor.white
        // 在滑块圆按钮添加图片
        slider.setThumbImage(UIImage(named:"slider_thumb"), for: .normal)
        
        progressView = UIProgressView.init()
        progressView.backgroundColor = UIColor.lightGray
        self.insertSubview(progressView, belowSubview: slider)
        progressView.snp.updateConstraints { (make) in
            make.left.right.equalTo(slider)
            make.centerY.equalTo(slider)
            make.height.equalTo(2)
        }
        
        progressView.tintColor = UIColor.red
        progressView.progress = 0
        
        timeLabel = UILabel()
        timeLabel.textColor = UIColor.white
        timeLabel.font = UIFont.systemFont(ofSize: 12)
        self.addSubview(timeLabel)
        timeLabel.snp.updateConstraints { (make) in
            make.right.equalTo(self)
            make.left.equalTo(slider.snp_right).offset(10)
            make.bottom.equalTo(self).inset(5)
        }
        
        
        playBtn = UIButton()
        self.addSubview(playBtn)
        playBtn.snp.updateConstraints { (make) in
            make.centerY.equalTo(slider)
            make.left.equalTo(self).offset(10)
            make.width.height.equalTo(30)
        }
        
        playBtn.setImage(UIImage(named: "player_pause"), for: .normal)
        playBtn.addTarget(self, action: #selector(playAndPause) , for: .touchUpInside)
        
        // 按下的时候
        slider.addTarget(self, action: #selector(sliderTouchDown), for: .touchDown)
        // 弹起的时候
        slider.addTarget(self, action: #selector(sliderTouchUpOut), for: .touchUpOutside)
        slider.addTarget(self, action: #selector(sliderTouchUpOut), for: .touchUpInside)
        slider.addTarget(self, action: #selector(sliderTouchUpOut), for: .touchCancel)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
  
    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer?.frame = self.bounds
    }
    
    
    @objc func sliderTouchDown(slider:UISlider){
        self.sliding = true
    }
    
    @objc func sliderTouchUpOut(slider:UISlider){
        delegate?.zzplayer(playerView: self, sliderTouchUpOut: slider)
    }
    
    @objc func playAndPause(btn:UIButton){
        let tmp = !playing
        playing = tmp
        if playing {
            playBtn.setImage(UIImage(named: "player_pause"), for: .normal)
        }else{
            playBtn.setImage(UIImage(named: "player_play"), for: .normal)
        }
        delegate?.zzplayer(playerView: self, playAndPause: btn)
    }
}


