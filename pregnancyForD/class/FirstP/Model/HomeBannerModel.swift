//
//  HomeBannerModel.swift
//  aileyun
//
//  Created by huchuang on 2017/7/28.
//  Copyright © 2017年 huchuang. All rights reserved.
//

import UIKit
import HandyJSON

class HomeBannerModel: NSObject, HandyJSON {
    
    var clickCount : String?
    var path : String?
    var id : NSNumber?
    var updateTime : NSNumber?
    var title : String?
    var hospitalId : NSNumber?
    var type : NSNumber?
    var createTime : NSNumber?
    var url : String?
    var order : String?
    
    override required init() {
        
    }
}
