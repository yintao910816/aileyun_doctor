//
//  GroupPatientModels.swift
//  pregnancyForD
//
//  Created by huchuang on 2018/3/6.
//  Copyright © 2018年 pg. All rights reserved.
//

import UIKit

class GroupPatientModels: NSObject {
    
    var doctorId : String?
    var docTagName : String?
    var doctorIds : String?
    var patientList : NSArray?{
        didSet{
            count = (patientList?.count)!
        }
    }
    
    
    var count : NSInteger = 0
    var isSelected : Bool = false

    override static func mj_objectClassInArray() -> [AnyHashable : Any]! {
        return ["patientList" : PatientModel.classForCoder()]
    }

}
