//
//  TemplateModel.swift
//  pregnancyForD
//
//  Created by pg on 2017/5/2.
//  Copyright © 2017年 pg. All rights reserved.
//

import UIKit
import HandyJSON

class TemplateModel: NSObject, HandyJSON {
    
    var templateValue : NSNumber?
    var docId : NSNumber?
    var templateContent : String?
    var id : NSNumber?

    override required init() { }
}
