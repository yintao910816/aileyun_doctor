//
//  HomeFunctionModel.swift
//  aileyun
//
//  Created by huchuang on 2017/7/28.
//  Copyright © 2017年 huchuang. All rights reserved.
//

import UIKit
import HandyJSON

class HomeFunctionModel: NSObject, HandyJSON {
    
    var isShow : NSNumber?
    var name : String?
    var path : String?
    var id : NSNumber?
    var modifydate : String?
    var isBind : NSNumber?
    var code : String?
    var remark : String?
    var isvalid : String?
    var issystem : String?
    var createdate : String?
    var url : String?

    required override init() {
        
    }
}
