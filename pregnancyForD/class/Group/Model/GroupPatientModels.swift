//
//  GroupPatientModels.swift
//  pregnancyForD
//
//  Created by huchuang on 2018/3/6.
//  Copyright © 2018年 pg. All rights reserved.
//

import UIKit
import HandyJSON

class GroupPatientModels: NSObject,HandyJSON {
    
    var doctorId : String?
    var docTagName : String?
    var doctorIds : String?
    var patientList: [PatientModel] = []
    
    var count : NSInteger {
        get { return patientList.count }
    }
    
    var isSelected : Bool = false
    
    override required init() { }
}
