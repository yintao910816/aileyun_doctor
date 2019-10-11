//
//  ConsultModel.swift
//  pregnancyForD
//
//  Created by pg on 2017/4/10.
//  Copyright © 2017年 pg. All rights reserved.
//

import UIKit
import HandyJSON

class ConsultModel: NSObject, HandyJSON {
    
    var content : String?
    var patientName : String?
    var doctorId : NSNumber?
    var headImg : String?
    var unReplyCount : NSNumber?
    
    var patientId : NSNumber?
    var doctorName : String?
    var currentStatus : NSNumber?
    var doctorIds : String?
    var lastestTime : NSNumber?

    var identityNo : String?
    
//    var t : NSNumber?
//    var tagName : String?
//    var tagValue : NSNumber?
//    var patientNickName : String?
        
    override var description: String {
        if let headImg = headImg {
            return String.init(format: "headImg: %@", self.headImg!)
        }else{
            return "headImg = nil"
        }
    }
  
    override required init() { }

}
