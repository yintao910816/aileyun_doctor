//
//  HttpRequestManager.swift
//  
//
//  Created by pg on 2017/4/24.
//
//

import Foundation
import HandyJSON

class HttpRequestManager {
    
    // 设计成单例
    static let shareIntance : HttpRequestManager = {
        let tools = HttpRequestManager()
        return tools
    }()
    
    
    //badgeNumber
    func unReplyCount(callback : @escaping (_ success : Bool, _ num : NSInteger)->()){
        HttpClient.shareIntance.POST(NOTREPLY_COUNT_URL, parameters: nil) { (result, ccb) in
            if ccb.infoCode == 200 {
//                HCPrint(message: result)
                
                let num = ccb.data as! NSInteger
                callback(true, num)
            }else{
                callback(false, 0)
            }
        }
    }
    
    
    // 上传音频
    func uploadVoice(doctorId : String, voiceFile : String, type : String, consultationId : NSInteger, callback : @escaping (_ success : Bool, _ message : String)->()){
        let dic = NSDictionary.init(dictionary: ["type" : type])
        HttpClient.shareIntance.uploadVoice(USER_FILE_UPLOAD, parameters: dic, voiceFile: voiceFile) { [unowned self](result, ccb) in
            if ccb.infoCode == 200 {
                let array = ccb.data as! [AnyObject]
                for i in array{
                    let j = i as! NSDictionary
                    let uploadPath = j["path"] as! String
                    
                    self.reply(doctorId: doctorId, consultationId: consultationId, content: "", urlList: uploadPath, type: "0", callback: { (success, message) in
                        if success == true{
                            callback(true, ccb.message)
                        }else{
                            callback(false, ccb.message)
                        }
                    })
                }
            }else{
                callback(false, ccb.message)
            }
        }
    }
    
    // 上传图片
    func uploadImage(doctorId : String, imageArr : [UIImage], type : String, consultationId : NSInteger, callback : @escaping (_ success : Bool, _ message : String)->()){
        let dic = NSDictionary.init(dictionary: ["type" : type])
//        HCPrint(message: dic)
        HttpClient.shareIntance.uploadImage(USER_FILE_UPLOAD, parameters: dic, imageArr : imageArr) { [unowned self](result, ccb) in
            if ccb.infoCode == 200 {
                let array = ccb.data as! [AnyObject]
//                HCPrint(message: array)
                let replyPathArr = NSMutableArray.init()
                for i in array{
                    let j = i as! NSDictionary
                    let uploadPath = j["path"] as! String
                    replyPathArr.add(uploadPath)
                }
                let replyS = replyPathArr.componentsJoined(by: ",")
//                HCPrint(message: replyS)
                self.reply(doctorId: doctorId, consultationId: consultationId, content: "", urlList: replyS, type: "0", callback: { (success, message) in
                    if success == true{
                        callback(true, ccb.message)
                    }else{
                        callback(false, ccb.message)
                    }
                })
            }else{
                callback(false, ccb.message)
            }
        }
    
    }
   
    
    
    func reply(doctorId : String, consultationId : NSInteger, content : String, urlList : String, type : String, callback : @escaping (_ success : Bool, _ message : String)->()){
        let dic = NSDictionary.init(dictionary: ["consultationId" : consultationId, "content" : content, "urlList" : urlList, "type" : type, "doctorId" : doctorId])
        
        HttpClient.shareIntance.POST(CONSULT_REPLY, parameters: dic) { (result, ccb) in
            if ccb.infoCode == 200 {
                callback(true, ccb.message)
            }else{
                callback(false, ccb.message)
            }
        }
    }
    
    
    // 退回提问
    func doctorReject(consultationId : NSInteger, callback : @escaping (_ success : Bool, _ message : String)->()){
        let dic = NSDictionary.init(dictionary: ["consultationId" : consultationId])
        
        HttpClient.shareIntance.POST(DOCTOR_REJECT, parameters: dic) { (result, ccb) in
            if ccb.infoCode == 200 {
                callback(true, ccb.message)
            }else{
                callback(false, ccb.message)
            }
        }
    }
    
    // 咨询模板操作信息
    func consultTemplate(templateValue : NSInteger, templateContent : String, opsType :NSInteger, callback : @escaping(_ success : Bool, _ array : [TemplateModel]?, _ message : String)->()){
        let dic = NSDictionary.init(dictionary: ["templateValue" : templateValue, "templateContent" : templateContent, "opsType" : opsType])
        HttpClient.shareIntance.POST(CONSULT_TEMPLATE_URL, parameters: dic) { (result, ccb) in
            if ccb.infoCode == 200 {
                guard opsType == 0 else{
//                    操作类型（0-查询；1-修改；2-删除；3-添加）
                    callback(true, nil, "更新成功！")
                    return
                }
                var arr = [TemplateModel]()
                let dicArr = ccb.data as! [Any]
                
                for i in dicArr{
                    let j = i as! [String : Any]
                    
                    FindRealClassForDicValue(dic: j)
                    
                    let tempM = JSONDeserializer<TemplateModel>.deserializeFrom(dict: j)!
                    arr.append(tempM)
                }
                callback(true, arr, "获取信息成功！")
            }else{
                callback(false, nil, ccb.message)
            }
        }
    }
    
    // 分组信息
    func tagsOperation(tagId : NSInteger, tagname : String, opsType : NSInteger, callback : @escaping (_ success : Bool, _ array : [TagGroupModel]?, _ message : String)->()){
        
        let dic = NSDictionary.init(dictionary: ["tagid" : tagId, "tagname" : tagname, "opsType" : opsType])
        HttpClient.shareIntance.POST(TAGS_OPERATION_URL, parameters: dic) { (result, ccb) in
            if ccb.infoCode == 200 {
                guard opsType == 0 else{
//                    操作类型（0-查询；1-修改；2-删除；3-添加）
                    callback(true, nil, "更新成功！")
                    return
                }
                var arr = [TagGroupModel]()
                let dicArr = ccb.data as! [Any]
                
                for i in dicArr{
                    let j = i as! [String : Any]
                    
                    let tempM = JSONDeserializer<TagGroupModel>.deserializeFrom(dict: j)!
                    arr.append(tempM)
                }
                callback(true, arr, "获取分组信息成功！")
            }else{
                callback(false, nil, ccb.message)
            }
        }
    }
    
    
    // 获取患者信息
    func getPatientInfo(patientId : NSInteger, doctorId : NSInteger, callback : @escaping (_ success : Bool, _ patientmodel : PatientModel?, _ message : String)->()){
        
        let dic = NSDictionary.init(dictionary: ["patientId" : patientId, "doctorId" : doctorId])
        HttpClient.shareIntance.POST(PATIENT_INFO_URL, parameters: dic) { (result, ccb) in
            
            if ccb.infoCode == 200 {
                let dic = ccb.data as! [String : Any]
                
                let patientModel = JSONDeserializer<PatientModel>.deserializeFrom(dict: dic)
                callback(true, patientModel, "获取信息成功！")
            }else{
                callback(false, nil, ccb.message)
            }
        }
    }
    
    // 更新患者信息
    func updatePatientInfo(patientId : NSInteger, type : NSInteger, value : Int, callback : @escaping (_ success : Bool, _ message : String)->()){
        let dic = NSDictionary.init(dictionary: ["patientId" : patientId, "type" : type, "value" : value])
//        类型0-tagvalue（tag值），1-price（最好一分为单位），2-屏蔽（0不屏蔽，1屏蔽）
        HttpClient.shareIntance.POST(UPDATE_PATIENT_INFO_URL, parameters: dic) { (result, ccb) in
            
            if ccb.infoCode == 200 {
                callback(true, "修改成功！")
            }else{
                callback(false, ccb.message)
            }
        }
    }
    
    // 医生信息
    func getUserInfo(callback : @escaping (_ success : Bool, _ userModel : UserModel?, _ message : String)->()){
        
        HttpClient.shareIntance.GET(USER_INFO_URL, parameters: nil) { (result, ccb) in
            
            if ccb.infoCode == 200 {
                let dic = ccb.data as! [String : Any]
//                FindRealClassForDicValue(dic: dic)
//                HCPrint(message: dic)
//                let userModel = UserModel.init(dic)
                let userModel = JSONDeserializer<UserModel>.deserializeFrom(dict: dic)
                callback(true, userModel, "获取信息成功！")
            }else{
                callback(false, nil, ccb.message)
            }
        }
    }
    
    // 获取回复列表
    func findPatientReplys(patientId : NSInteger, doctorId : NSInteger, callback : @escaping (_ success : Bool, _ patientReply : [PatientReplyModel]?, _ message : String)->()){
        
        let dic = NSDictionary.init(dictionary: ["patientId" : patientId, "doctorId" : doctorId])
        HttpClient.shareIntance.POST(FIND_PATIENT_REPLYS, parameters: dic) { (result, ccb) in
            
//            HCPrint(message: result)
            
            if ccb.infoCode == 200 {
                
                var arr = [PatientReplyModel]()
                let dicArr = ccb.data as! [Any]
                for i in dicArr{
                    let j = i as! [String : Any]
//                    let tempM = PatientReplyModel.init(j)
//                    arr.append(tempM)
                }
                callback(true, arr, "获取信息成功！")
            }else{
                callback(false, nil, ccb.message)
            }
        }
    }
    
    // 更新医生信息
    func updateinfo(infoDic : NSDictionary, callback : @escaping (_ success : Bool, _ message : String)->()){
        HttpClient.shareIntance.POST(UPDATE_INFO_URL, parameters: infoDic) { (result, ccb) in
            if ccb.infoCode == 200 {
                callback(true, "修改成功！")
            }else{
                callback(false, ccb.message)
            }
        }
    }
    
    // 获取咨询列表
    func getConsultList(pageNo : NSInteger, pageSize : NSInteger, callback : @escaping (_ success : Bool, _ ModelArray : [ConsultModel]?, _ hasNext : Bool, _ message : String)->()) -> () {
        
        let dic = NSDictionary.init(dictionary: ["pageNo" : pageNo, "pageSize" : pageSize])
        HttpClient.shareIntance.POST(CONSULT_LIST_URL, parameters: dic) { (result, ccb) in
            
            if ccb.infoCode == 200 {
                
                let dic = ccb.data as! [String : Any]
                let hasNext = (dic["hasNext"] as! NSNumber).intValue == 0 ? false : true
                let tempArray = dic["result"] as! [Any]
                
                guard tempArray.count >= 1 else{
                    callback(false, nil, false, ccb.message)
                    return
                }
                
                var patientLArray = [ConsultModel]()
                
                for i in tempArray {
                    let tempI = i as! [String : Any]
                    let j = JSONDeserializer<ConsultModel>.deserializeFrom(dict: tempI)!
                    patientLArray.append(j)
                }
                
                callback(true, patientLArray, hasNext, "获取列表成功！")
            }else{
                callback(false, nil, false, ccb.message)
            }
        }
    }

    
    // 获取患者列表
    func getPatientList(callback : @escaping (_ success : Bool, _ ModelArray : [PatientModel]?, _ message : String)->()) -> () {
        
        HttpClient.shareIntance.POST(PATIENTLIST_URL, parameters: nil) { (result, ccb) in
            
            if ccb.infoCode == 200 {
                var patientArray = [PatientModel]()

                let tempArray = ccb.data as! [Any]
                for i in tempArray {
                    let tempI = i as! [String : Any]
                    let j = JSONDeserializer<PatientModel>.deserializeFrom(dict: tempI)!
                    patientArray.append(j)
                }
                callback(true, patientArray, "获取列表成功！")
            }else{
                callback(false, nil, ccb.message)
            }
        }
    }
    
    // 获取验证码
    func SendSms(_ number : String, callback : @escaping (Bool, String)->()){
        HttpClient.shareIntance.GET(USER_SEND_SMS_URL, parameters: NSDictionary.init(dictionary: ["phone" : number])) { (result, ccb) in
            callback(ccb.success(), ccb.message)
        }
    }
    
    //  登录
    func loginBySms(_ number : String, code : String, callback : @escaping (_ success : Bool, _ userModel : UserModel?, _ message : String)->()) {
        
        HttpClient.shareIntance.GET(USER_VALIFY_SMS_URL, parameters: ["phone" : number, "code" : code]) { (result, ccb) in
            
            if ccb.infoCode == 200 {
                let userDic = ccb.data as! [String : Any]
                UserDefaults.standard.set(true, forKey:kReceiveRemoteNote)
                
                UserDefaults.standard.set(number, forKey: kCurrentUserPhone)
                UserDefaults.standard.set(userDic, forKey: kCurrentUser)
            
//                callback(ccb.success(), UserModel.init(userDic), ccb.message)
                callback(ccb.success(), JSONDeserializer<UserModel>.deserializeFrom(dict: userDic), ccb.message)
            }else{
                callback(false, nil, ccb.message)
            }
        }
    }
    
    
    func HC_updateConsultStatus(consultId : NSInteger, doctorId : NSInteger, callback : @escaping (_ lock : Bool)->()){
        let dic = NSDictionary.init(dictionary: ["consultId" : consultId, "doctorId" : doctorId])
        HttpClient.shareIntance.POST(UPDATE_CONSULT_STATUS, parameters: dic) { (result, ccb) in
            if ccb.infoCode == 200 {
//                HCPrint(message: result)
                if ccb.data == nil {
                    callback(true)
                    return
                }
                let docId = (ccb.data as! NSNumber).intValue
                if docId == 0 || docId == doctorId{
                    callback(true)
                }else{
                    callback(false)
                }
            }else{
                callback(false)
            }
        }
    }
    
    func HC_unlockConsultStatus(patientId : NSInteger, memberDoctorId : NSInteger, leaderDoctorId : NSInteger){
        let dic = NSDictionary.init(dictionary: ["patientId" : patientId, "memberDoctorId" : memberDoctorId, "leaderDoctorId" : leaderDoctorId])
        HttpClient.shareIntance.POST(UNLOCK_CONSULT_STATUS, parameters: dic) { (result, ccb) in
        }
    }
    
    func HC_getUpdateLock(callback : @escaping (Bool)->()){
        let dic = NSDictionary.init(dictionary: ["type" : 4])
        HttpClient.shareIntance.POST(UPDATE_LOCK, parameters: dic) { (result, ccb) in
            if ccb.infoCode == 200 {
                let dic = result as! [String : Any]
                guard dic["data"] != nil else {
                    callback(false)
                    return
                }
                let dataDic = dic["data"] as! [String : Any]
                let isOn = dataDic["isOn"] as! NSNumber
                if isOn.intValue == 1{
                    callback(true)
                }else{
                    callback(false)
                }
            }else{
                callback(false)
            }
        }
    }
    
    // 获取Ht5地址  keyCode
    func HC_getH5URL(keyCode : String, callback : @escaping (Bool, String)->()){
        let dic = NSDictionary.init(dictionary: ["keyCode" : keyCode])
        HttpClient.shareIntance.GET(HC_HREF_H5, parameters: dic) { (result, ccb) in
            if ccb.success() {
                let dic = ccb.data as? [String : Any]
                guard dic != nil else{
                    callback(false, "数据解析失败")
                    return
                }
                let urlS = dic!["value"] as! String
                callback(true, urlS)
            }else{
                callback(false, "失败")
            }
        }
    }
    
    // 获取患者token
    func HC_getPatiToken(doctorToken : String, patientId : NSInteger, callback : @escaping (Bool, String)->()){
        let dic = NSDictionary.init(dictionary: ["doctorToken" : doctorToken, "patientId" : patientId])
        HttpClient.shareIntance.GET(HC_GET_PATI_TOKEN, parameters: dic) { (result, ccb) in
            if ccb.success() {
                let dic = ccb.data as? [String : Any]
                guard dic != nil else{
                    callback(false, "数据解析失败")
                    return
                }
                let token = dic!["patientToke"] as! String
                callback(true, token)
            }else{
                callback(false, "失败")
            }
        }
    }
    
    // 查询是否是member
    func HC_isMember(callback : @escaping (Bool, String)->()){
        HttpClient.shareIntance.GET(HC_IS_MEMBER, parameters: nil) { (result, ccb) in
//            HCPrint(message: result)
            if ccb.success(){
                let num = ccb.data as? NSNumber
                guard let n = num else{
                    callback(false, "无返回")
                    return
                }
                if n.intValue == 1{
                    callback(true, "解析成功")
                }else{
                    callback(false, "解析成功")
                }
            }else{
                callback(false, "请求失败")
            }
        }
    }
    
    func HC_functionList(callback : @escaping (Bool, [HomeFunctionModel]?)->()){
        HttpClient.shareIntance.GET(HC_FUNCTION_LIST, parameters: nil) { (result, ccb) in
//            HCPrint(message: result)
            if ccb.success(){
                let arr = ccb.data as? [[String : Any]]
                if let arr = arr {
                    var modelArr = [HomeFunctionModel]()
                    for i in arr {
                        let model = JSONDeserializer<HomeFunctionModel>.deserializeFrom(dict: i)!
                        modelArr.append(model)
                    }
                    
                    // 测试
//                    let dic =  [
//                        "isShow": 1,
//                        "name": "胚胎查看",
//                        "isBind": 1,
//                        "type": "doctor",
//                        "path": "http://www.ivfcn.com/attach/icon/docfunc/consult.png",
//                        "id": 17,
//                        "modifydate": "2018-01-17 14:30:24.0",
//                        "code": "CONSULT_ONLINE",
//                        "remark": "查看胚胎发育状态",
//                        "isvalid": "1",
//                        "issystem": "1",
//                        "createdate": "2018-01-17 14:30:24.0",
//                        "url": "SHOW_PIC"
//                        ] as [String : Any]
//                    let model = HomeFunctionModel.init(dic)
//                    modelArr.append(model)
                    
                    
                    callback(true, modelArr)
                }else{
                    callback(false, nil)
                }
            }else{
                callback(false, nil)
            }
        }
    }
    
    
    func HC_bannerList(callback : @escaping (Bool, [HomeBannerModel]?)->()){
        HttpClient.shareIntance.GET(HC_BANNER_LIST, parameters: nil) { (result, ccb) in
//            HCPrint(message: result)
            if ccb.success(){
                let arr = ccb.data as? [[String : Any]]
                if let arr = arr {
                    var modelArr = [HomeBannerModel]()
                    for i in arr {
                        let model = JSONDeserializer<HomeBannerModel>.deserializeFrom(dict: i)!
                        modelArr.append(model)
                    }
                    callback(true, modelArr)
                }else{
                    callback(false, nil)
                }
            }else{
                callback(false, nil)
            }
        }
    }
    
    func HC_dynamicList(pageNum : NSInteger, pageSize : NSInteger, callback : @escaping (Bool, [ConsultMessageModel]?, [NotificationModel]?)->()){
        let dic = NSDictionary.init(dictionary: ["pageNum" : pageNum, "pageSize" : pageSize])
        HttpClient.shareIntance.GET(HC_DYNAMIC_LIST, parameters: dic) { (result, ccb) in
//            HCPrint(message: result)
            if ccb.success(){
                let dic = ccb.data as? [String : Any]
                if let dic = dic {
                    var modelArr = [ConsultMessageModel]()
                    var notiArr = [NotificationModel]()
                    for (key, value) in dic{
                        if key == "咨询信息"{
                            if let arr = value as? [[String : Any]]{
                                for i in arr{
//                                    FindRealClassForDicValue(dic: i)
                                    let model = JSONDeserializer<ConsultMessageModel>.deserializeFrom(dict: i)!
                                    modelArr.append(model)
                                }
                            }
                        }else if key == "院内公告"{
                            if let arr = value as? [[String : Any]]{
                                for i in arr{
//                                    FindRealClassForDicValue(dic: i)
                                    let model = JSONDeserializer<NotificationModel>.deserializeFrom(dict: i)!

                                    notiArr.append(model)
                                }
                            }
                        }
                    }
                    callback(true, modelArr, notiArr)
                }else{
                    callback(false, nil, nil)
                }
            }else{
                callback(false, nil, nil)
            }
        }
    }
    
    func HC_addClickCount(id : NSInteger, callback : @escaping (Bool)->()){
        let urlS = String.init(format: "%@%d", HC_CLICK_COUNT, id)
        HttpClient.shareIntance.GET(urlS, parameters: nil) { (result, ccb) in
//            HCPrint(message: result)
        }
    }
    
    
    func HC_findPatient(patientName : String, callback :  @escaping (Bool, [SearchPatientModel], [SearchCycleModel])->()){
        let dic = NSDictionary.init(dictionary: ["patientName" : patientName])
        HttpClient.shareIntance.GET(HC_FIND_PATIENT, parameters: dic) { (result, ccb) in
//            HCPrint(message: result)
            var referArr = [SearchPatientModel]()
            var reproductArr = [SearchCycleModel]()
            if ccb.success(){
                let dic = ccb.data as? [String : Any]
                if let dic = dic{
                    if let referedGroupArr = dic["referedGroups"] as? [[String : Any]]{
                        for dic in referedGroupArr{
//                            FindRealClassForDicValue(dic: dic)
//                            HCPrint(message: "-----------------")
                            let m = JSONDeserializer<SearchPatientModel>.deserializeFrom(dict: dic)!
                            referArr.append(m)
                        }
                    }
                    if let reproductiveGroupsArr = dic["reproductiveGroups"] as? [[String : Any]]{
                        for dic in reproductiveGroupsArr{
//                            FindRealClassForDicValue(dic: dic)
//                            HCPrint(message: "-----------------")
                            let model = JSONDeserializer<SearchCycleModel>.deserializeFrom(dict: dic)!
                            reproductArr.append(model)
                        }
                    }
                    callback(true, referArr, reproductArr)
                }
            }else{
                callback(false, referArr, reproductArr)
            }
        }
    }
    
    
    // 获取咨询列表
    func HC_getConsultList(pageNum : NSInteger, pageSize : NSInteger, callback : @escaping (_ success : Bool, _ ModelArray : [ConsultModel]?, _ hasNext : Bool, _ message : String)->()) -> () {
        
        let dic = NSDictionary.init(dictionary: ["pageNum" : pageNum, "pageSize" : pageSize])
        HttpClient.shareIntance.POST(HC_CONSULT_LIST, parameters: dic) { (result, ccb) in
            
//            HCPrint(message: result)
            
            if ccb.infoCode == 200 {
                
                let dic = ccb.data as! [String : Any]
                let hasNext = (dic["hasNextPage"] as! NSNumber).intValue == 0 ? false : true
                let tempArray = dic["list"] as! [Any]
                
                guard tempArray.count >= 1 else{
                    callback(false, nil, false, ccb.message)
                    return
                }
                
                var patientLArray = [ConsultModel]()
                
                for i in tempArray {
                    let tempI = i as! [String : Any]
//                    FindRealClassForDicValue(dic: tempI)
                    let j = JSONDeserializer<ConsultModel>.deserializeFrom(dict: tempI)!

                    patientLArray.append(j)
                }
                callback(true, patientLArray, hasNext, "获取列表成功！")
            }else{
                callback(false, nil, false, ccb.message)
            }
        }
    }

    
    // 获取回复列表
    func HC_findPatientReplys(patientId : NSInteger, doctorIds : String, pageNum : NSInteger, pageSize : NSInteger, callback : @escaping (_ success : Bool, _ patientReply : [PatientReplyModel]?, _ hasNext : Bool, _ message : String)->()){
        
        let dic = NSDictionary.init(dictionary: ["patientId" : patientId, "doctorIds" : doctorIds, "pageNum" : pageNum, "pageSize" : pageSize])
        HttpClient.shareIntance.POST(HC_CONSULT_DETAIL, parameters: dic) { (result, ccb) in
            
            HCPrint(message: result)
            
            if ccb.infoCode == 200 {
                if let dic = ccb.data as? [String : Any]{
                    let hasNext = (dic["hasNextPage"] as! NSNumber).intValue == 0 ? false : true
                    
                    if let tempArray = dic["list"] as? [[String : Any]]{
                        guard tempArray.count > 0 else{
                            callback(false, nil, false, ccb.message)
                            return
                        }
                        var replyArr = [PatientReplyModel]()
                        for i in tempArray {
                            
//                            FindRealClassForDicValue(dic: i)
//                            HCPrint(message: "_____________")
                            
//                            if let replyArr = i["replyList"] as? [[String : Any]]{
//                                for dic in replyArr{
//                                    FindRealClassForDicValue(dic: dic)
//                                    HCPrint(message: "_____________")
//                                }
//                            }
                            
                            let j = JSONDeserializer<PatientReplyModel>.deserializeFrom(dict: i)
                            replyArr.append(j!)
                        }
                        callback(true, replyArr, hasNext, "获取列表成功！")
                    }
                }
            }else{
                callback(false, nil, false, ccb.message)
            }
            
        }
    }
    
    
    // 获取患者列表
    func HC_getPatientList(callback : @escaping (_ success : Bool, _ ModelArray : [GroupPatientModels]?, _ message : String)->()) -> () {
        
        HttpClient.shareIntance.POST(HC_PATIENT_LIST, parameters: nil) { (result, ccb) in
            
//            HCPrint(message: result)
            if ccb.infoCode == 200 {
                
                var groupModels = [GroupPatientModels]()
                
                if let dic = ccb.data as? [[String : Any]]{
                    for i in dic{
                        
//                        FindRealClassForDicValue(dic: i)
//                        HCPrint(message: "_____________")
//                        if let patiArr = i["patientList"] as? [[String : Any]]{
//                            for dic in patiArr{
//                                FindRealClassForDicValue(dic: dic)
//                                HCPrint(message: "_____________")
//                            }
//                        }
                        
                        let j = JSONDeserializer<GroupPatientModels>.deserializeFrom(dict: i)
                        groupModels.append(j!)
                    }
                }
                callback(true, groupModels, ccb.message)
            }else{
                callback(false, nil, ccb.message)
            }
        }
    }
    
}



