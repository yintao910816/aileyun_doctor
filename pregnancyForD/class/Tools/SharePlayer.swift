//
//  SharePlayer.swift
//  pregnancyForD
//
//  Created by pg on 2017/5/18.
//  Copyright © 2017年 pg. All rights reserved.
//

import UIKit

class SharePlayer: NSObject {

    lazy var audioPlayer : HCAudioPlayer = {
        var p = HCAudioPlayer.init()
        do {
            let pathS = Bundle.main.path(forResource: "defaultVoice.wav", ofType: nil)
            let url = URL.init(string: pathS!)
            try p = HCAudioPlayer.init(contentsOf: url!)
            p.prepareToPlay()
            return p
        } catch {
        }
        return p
    }()
    
    // 设计成单例
    static let shareIntance : SharePlayer = {
        let tools = SharePlayer()
        return tools
    }()
    
    

}
