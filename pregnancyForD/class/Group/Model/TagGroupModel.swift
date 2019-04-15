//
//  TagGroupModel.swift
//  pregnancyForD
//
//  Created by pg on 2017/4/27.
//  Copyright © 2017年 pg. All rights reserved.
//

import UIKit

class TagGroupModel: NSObject {
    
    var tagName : String?
    var doctorId : NSNumber?
    var id : NSNumber?
    var total : NSInteger?
    
    var isSelected = false;
    
    convenience init(_ dic : [String : Any]) {
        self.init()
        setValuesForKeys(dic)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        //
    }


}
