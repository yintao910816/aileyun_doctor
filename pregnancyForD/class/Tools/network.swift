//
//  network.swift
//  pregnancyForD
//
//  Created by pg on 2017/4/20.
//  Copyright © 2017年 pg. All rights reserved.
//

import Foundation    //罗延琼


let HTTP_RESULT_SERVER_ERROR = "服务器出错！"
let HTTP_RESULT_NETWORK_ERROR = "网络出错，请检查网络连接！"



//H5界面地址  keyCode
let HC_HREF_H5 = "http://wx.ivfcn.com/doctor/hrefH5"
//获取患者token
let HC_GET_PATI_TOKEN = "http://wx.ivfcn.com/doctor/docToPatient"


let IMAGE_URL = "https://www.ivfcn.com"




//let HTTP_ROOT_URL = "http://admin.ivfcn.com:8082"
//let HTTP_ROOT_URL = "http://app.ivfcn.com:8091"

let HTTP_ROOT_URL = "https://www.ivfcn.com"

//let HTTP_ROOT_URL = "http://58.51.90.231:8091"

//let HTTP_ROOT_URL = "http://192.168.0.109:8087"




//let HTTP_HOST_URL = HTTP_ROOT_URL.appending("/doctor-api/api/")

let HTTP_HOST_URL = HTTP_ROOT_URL.appending("/app/")

//查询是否是组员
let HC_IS_MEMBER = HTTP_HOST_URL + "doctor/queryTeamMember.do"

// 获取验证码
let USER_SEND_SMS_URL = HTTP_HOST_URL + "doctor/validateCode.do"
// 登录
let USER_VALIFY_SMS_URL = HTTP_HOST_URL + "doctor/valify.do"
//let USER_VALIFY_SMS_URL = HTTP_HOST_URL + "doctor/login"

// 在线咨询列表
let CONSULT_LIST_URL = HTTP_HOST_URL + "doctor/consult/getConsultList.do"

// 当前未回复数量
let NOTREPLY_COUNT_URL = HTTP_HOST_URL + "doctor/consult/getAllUnReplyCount.do"
// 获取回复列表
let FIND_PATIENT_REPLYS = HTTP_HOST_URL + "doctor/findPatientReplys.do"
// 咨询模板操作信息
let CONSULT_TEMPLATE_URL = HTTP_HOST_URL + "doctor/consultTemplateOperation.do"
// 拒绝提问
let DOCTOR_REJECT = HTTP_HOST_URL + "doctor/doctorReject.do"
// 上传图片
let USER_FILE_UPLOAD = HTTP_HOST_URL + "attach/upload.do"
// 回复文字
let CONSULT_REPLY = HTTP_HOST_URL + "doctor/consultedReply.do"

// 患者列表
let PATIENTLIST_URL = HTTP_HOST_URL + "doctor/consult/getPatientList.do"

// 患者详情
let PATIENT_INFO_URL = HTTP_HOST_URL + "doctor/consult/getPatientInfo.do"
// 更新患者信息,包括咨询价格,是否屏蔽患者提问,分组
let UPDATE_PATIENT_INFO_URL = HTTP_HOST_URL + "doctor/consult/updatePatientInfo.do"
// 分组信息
let TAGS_OPERATION_URL = HTTP_HOST_URL + "doctor/tagsOperation.do"

// 获取医生信息
let USER_INFO_URL = HTTP_HOST_URL + "doctor/userInfo.do"
// 更新患者信息,包括咨询价格,是否屏蔽患者提问,分组
let UPDATE_INFO_URL = HTTP_HOST_URL + "doctor/updateinfo.do"
// 反馈历史数据
let FEEDBACK_HISTORY = HTTP_HOST_URL + "common/feedbackHistory.do"
// 提交反馈
let SEND_FEEDBACK = HTTP_HOST_URL + "common/sendFeedback.do"

//查询是否打开更新提示
let UPDATE_LOCK = HTTP_HOST_URL + "common/validateVersionInfo.do"

//加锁咨询状态
let UPDATE_CONSULT_STATUS = HTTP_HOST_URL + "doctor/consult/updateConsultStatus.do"

//解绑状态
let UNLOCK_CONSULT_STATUS = HTTP_HOST_URL + "doctor/consult/unlockConsultStatus.do"









//新路径   新接口
let HC_ROOT_URL = "http://admin.ivfcn.com:8082/doctor-api/api/doctor/"

//let HC_ROOT_URL = "http://192.168.0.109:8087/doctor-api/api/doctor/"

//let HC_ROOT_URL = "http://192.168.0.115:8087/doctor-api/api/doctor/"




let HC_FUNCTION_LIST = HC_ROOT_URL + "index/functionList"

let HC_BANNER_LIST = HC_ROOT_URL + "index/bannerList"

let HC_DYNAMIC_LIST = HC_ROOT_URL + "index/dynamicList"

let HC_CLICK_COUNT = HC_ROOT_URL + "sysApplication/addClickCount/"

let HC_FIND_PATIENT =  HC_ROOT_URL + "cycleMedicalHistory/getPatientsByName"

//咨询列表
let HC_CONSULT_LIST = HC_ROOT_URL + "consult/getPatientConsultList"
//咨询详情
let HC_CONSULT_DETAIL = HC_ROOT_URL + "consult/getConsultDetailsByPId"
//患者列表
let HC_PATIENT_LIST = HC_ROOT_URL + "consult/getConsultsPatientList"

let UPDATE_DOCTOR_INFO = HC_ROOT_URL + "updateinfo.do"
//获取医生信息
let DOCTOR_INFO_URL = HC_ROOT_URL + "doctor/userInfo.do"
