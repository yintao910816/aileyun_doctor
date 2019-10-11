//
//  SearchPatientModel.swift
//  pregnancyForD
//
//  Created by huchuang on 2018/2/24.
//  Copyright © 2018年 pg. All rights reserved.
//

import UIKit
import HandyJSON

class SearchPatientModel: NSObject, HandyJSON {
    
    var patientId : NSNumber?
    var doctorIds : String?
    var hasScheme : NSNumber?
    var identityNo : String?
    var name : String?
    
    var headPhoto : String?
    var sex : NSNumber?

    required override init() {

    }
}
