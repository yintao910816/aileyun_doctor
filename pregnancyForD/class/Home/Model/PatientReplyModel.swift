//
//  PatientReplyModel.swift
//  pregnancyForD
//
//  Created by pg on 2017/4/26.
//  Copyright © 2017年 pg. All rights reserved.
//

import UIKit

class PatientReplyModel: NSObject {
    
    var content : String?
    var patientName : String?
    var consultImglist : NSArray?
    var consultId : NSNumber?
    var doctorName : String?
    
    var patientId : NSNumber?
    var currentStatus : NSNumber?
    var createTime : NSNumber?
    var lastestTime : NSNumber?
    var headImg : String?
    
    var replyList : NSArray?
    var consultImg : String?

    
    var endTime : String = ""
    
//    var doctorId : NSNumber?


    override static func mj_objectClassInArray() -> [AnyHashable : Any]! {
        return ["replyList" : ReplyDetailModel.classForCoder()]
    }
}
