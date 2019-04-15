//
//  Common.swift
//  pregnancyForD
//
//  Created by pg on 2017/4/10.
//  Copyright © 2017年 pg. All rights reserved.
//

import Foundation
import Photos
import SVProgressHUD
import AFNetworking
import SnapKit
import MJExtension


typealias blankBlock = ()->()
typealias changeBlock = (_ info : String)->()

typealias imgArrBlock = ( _ info : [String], _ index : NSInteger )->()


let kDefaultThemeColor = UIColor.init(red: 254/255.0, green: 127/255.0, blue: 146/255.0, alpha: 1)
let kDefaultBlueColor = UIColor.init(red: 80/255.0, green: 155/255.0, blue: 202/255.0, alpha: 1)
let kDefaultTabBarColor = UIColor.init(red: 248/255.0, green: 248/255.0, blue: 248/255.0, alpha: 1)
let kdivisionColor = UIColor.init(red: 228/255.0, green: 227/255.0, blue: 229/255.0, alpha: 1)
let kNotReplyCellColor = UIColor.init(red: 255/255.0, green: 241/255.0, blue: 241/255.0, alpha: 1)
let kGroupTextColor = UIColor.init(red: 181/255.0, green: 181/255.0, blue: 181/255.0, alpha: 1)
let kLightGrayColor = UIColor.init(red: 248/255.0, green: 248/255.0, blue: 248/255.0, alpha: 1)

let kTextColor = UIColor.init(red: 51/255.0, green: 51/255.0, blue: 51/255.0, alpha: 1)
let kLightTextColor = UIColor.init(red: 120/255.0, green: 120/255.0, blue: 120/255.0, alpha: 1)


let TypeText = "Text"
let TypeVoice  = "Voice"
let TypePic = "Picture"
let TypeMix = "Mix"

//字体
let kReguleFont = "PingFangSC-Regular"
let kBoldFont = "PingFangSC-Semibold"


let kTextSize : CGFloat = 16

let scrollPicHeight : CGFloat = 215
let FuncSizeWidth = SCREEN_WIDTH / 2
let CellHeight : CGFloat = 85
let DefaultGap : CGFloat = 1

let DynamicHeight : CGFloat = 280

// 通知常量
let ShowPhotoNotification = "ShowPhotoNotification"

let UpdatePatientInfo = "updatePatientInfo"
let AddGroupSuccess = "AddGroupSuccess"
let RemoveGroupSuccess = "RemoveGroupSuccess"

let RejectConsultSuccess = "RejectConsultSuccess"
let ReplyConsultSuccess = "ReplyConsultSuccess"

let ModifyDoctorIntro = "ModifyDoctorIntro"

let ScrollImageV = "ScrollImageV"




//微信授权
let weixinAppid = "wx7f7b518ed2335fb5"
let weixinSecret = "e06b00ed30b61c2aba38a396318c8aa3"

let QQAppid = "1106202365"

let kappID = "1087377513"


let SCREEN_WIDTH = UIScreen.main.bounds.size.width
let SCREEN_HEIGHT = UIScreen.main.bounds.size.height

let PhotoPickerViewHeight = 200
let KDefaultPadding = 16
let PhotoesWidth = (SCREEN_WIDTH - 160) / 3


let kCurrentUser = "kCurrentUser"
let kCurrentUserPhone = "kCurrentUserPhone"

let kReceiveRemoteNote = "kReceiveRemoteNote"


func HCGetSize(content : NSString, maxWidth : CGFloat, font : UIFont) -> CGSize {
    let maxSize = CGSize.init(width: maxWidth, height: 9999)
    let textSize = content.boundingRect(with: maxSize, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil).size
    return textSize
}


func HCTextSize(_ label : UILabel) -> CGSize {
    let maxSize = CGSize.init(width: label.frame.size.width, height: 9999)
    let textSize = (label.text as! NSString).boundingRect(with: maxSize, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName: label.font], context: nil).size
    
    return textSize
}

func stringFromInterval(interval : NSNumber)->String{
    
    //        let scanner = Scanner(string: interval)
    //        var milliseconds : Int64 = 0
    //        scanner.scanInt64(&milliseconds)
    //        let timeStamp = TimeInterval(milliseconds)/1000.0
    
    let milliseconds = interval.int64Value
    let timeStamp = TimeInterval.init(milliseconds)/1000.0
    let date = Date.init(timeIntervalSince1970: timeStamp)
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    let defaultTimeZoneStr = formatter.string(from: date)
    
    return defaultTimeZoneStr
}

func HCPrint<T>(message: T,
              logError: Bool = false,
              file: String = #file,
              method: String = #function,
              line: Int = #line)
{
    if logError {
        print("\((file as NSString).lastPathComponent)[\(line)], \(method): \(message)")
    } else {
        #if DEBUG
            print("\((file as NSString).lastPathComponent)[\(line)], \(method): \(message)")
        #endif
    }
}

func FindPhotoFromSystem()-> [UIImage] {
    var arr = [UIImage]()
    let smartAlbums = PHAssetCollection.fetchAssetCollections(with: PHAssetCollectionType.smartAlbum, subtype: PHAssetCollectionSubtype.albumRegular, options: nil)
    
    let opt = PHImageRequestOptions()
    opt.isSynchronous = true
    let imageManager = PHImageManager()
    
    for i in 0..<smartAlbums.count {
        
        guard arr.count < 10 else {
            break
        }
        
        let col = smartAlbums[i]
        if col.isKind(of: PHAssetCollection.classForCoder()) {
            let assetCol = col as! PHAssetCollection
            let fetchResult = PHAsset.fetchAssets(in: assetCol, options: nil)
            if fetchResult.count > 0 {
                for j in 0..<fetchResult.count {
                    
                    guard arr.count < 10 else {
                        break
                    }
                    
                    let asset = fetchResult[j]
                    imageManager.requestImage(for: asset, targetSize: CGSize.init(width: 100, height: 150), contentMode: PHImageContentMode.aspectFit, options: opt, resultHandler: { ( image : UIImage?, info : [AnyHashable : Any]?) in
                        if let image = image {
                            arr.append(image)
                        }
                    })
                }
            }
        }
    }
    return arr
}

func HCShowInfo(info : String){
    SVProgressHUD.showInfo(withStatus: info)
    SVProgressHUD.dismiss(withDelay: 2)
}

func HCShowError(info : String){
    SVProgressHUD.showError(withStatus: info)
    SVProgressHUD.dismiss(withDelay: 2)
}

func FindRealClassForDicValue(dic : [String : Any]){
    for key in dic.keys{
        let value = dic[key]
        let ob = value as AnyObject
        
        let s = "var \(key) : \(ob.classForCoder) ?"
        let tempS = s.replacingOccurrences(of: "Optional(", with: "").replacingOccurrences(of: ") ", with: "").replacingOccurrences(of: "NSString", with: "String")
        
        print(tempS)
    }
}

// 视频转换
func convertVideoQuailtyWithInputURL(inputUrl:URL, outputUrl:URL, completeHandler:@escaping (_ handler:AVAssetExportSession)->Void){
    
    let avAsset = AVURLAsset.init(url: inputUrl)
    
    let exportSession = AVAssetExportSession.init(asset: avAsset, presetName: AVAssetExportPresetHighestQuality)
        
    exportSession?.outputFileType = AVFileTypeMPEG4
    exportSession?.outputURL = outputUrl
    exportSession?.shouldOptimizeForNetworkUse = true
    
    exportSession?.exportAsynchronously(completionHandler: { () -> Void in
        
        switch exportSession!.status {
            case AVAssetExportSessionStatus.cancelled:
            print("AVAssetExportSessionStatusCancelled")
            
            case AVAssetExportSessionStatus.unknown:
            print("AVAssetExportSessionStatusUnknown")
            
            case AVAssetExportSessionStatus.waiting:
            print("AVAssetExportSessionStatus.Waiting")
            
            case AVAssetExportSessionStatus.exporting:
            
            print("AVAssetExportSessionStatus.Exporting")
            
            case AVAssetExportSessionStatus.completed:  //转码完成后在这里操作后续
            print("AVAssetExportSessionStatusCompleted")

            completeHandler(exportSession!)
            
            default:
            break
        }
    })
}

// 相册权限
func checkPhotoLibraryPermissions() -> Bool {
    
    let library : PHAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
    if(library == PHAuthorizationStatus.denied || library == PHAuthorizationStatus.restricted || library == PHAuthorizationStatus.notDetermined){
        return false
    }else {
        return true
    }
}

func authorizationForPhotoLibrary(confirmBlock : @escaping blankBlock){
    
    PHPhotoLibrary.requestAuthorization { (status) in
        if status == PHAuthorizationStatus.authorized{
            DispatchQueue.main.async {
                confirmBlock()
            }
        }else if status == PHAuthorizationStatus.denied{
            HCShowError(info: "未能获取图片！")
        }
    }
}

// 相机权限
func checkCameraPermissions() -> Bool {

    let authStatus : AVAuthorizationStatus = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
    
    if authStatus == AVAuthorizationStatus.denied || authStatus == AVAuthorizationStatus.restricted || authStatus == AVAuthorizationStatus.notDetermined {
        return false
    }else {
        return true
    }
}

func authorizationForCamera(confirmBlock : @escaping blankBlock){
    
    AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo) { (granted) in
        if granted == true {
            confirmBlock()
        }else{
            HCShowError(info: "未能开启相机！")
        }
    }
}


// 麦克风权限
func checkMicrophonePermissions() -> Bool {
    let authStatus : AVAuthorizationStatus = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeAudio)
    if authStatus == AVAuthorizationStatus.denied || authStatus == AVAuthorizationStatus.restricted || authStatus == AVAuthorizationStatus.notDetermined {
        return false
    }else {
        return true
    }
}

func authorizationForMicrophone(confirmBlock : @escaping blankBlock){
    AVAudioSession.sharedInstance().requestRecordPermission { (granted) in
        if granted == true {
            confirmBlock()
        }else{
            HCShowError(info: "未能开启语音！")
        }
    }
}


// 随机颜色
func randomColor()-> UIColor{
    let red = CGFloat(arc4random_uniform(255))/CGFloat(255.0)
    let green = CGFloat(arc4random_uniform(255))/CGFloat(255.0)
    let blue = CGFloat(arc4random_uniform(255))/CGFloat(255.0)
    let alpha = CGFloat(arc4random_uniform(255))/CGFloat(255.0)
    
    return UIColor.init(red:red, green:green, blue:blue , alpha: alpha)
}


//显示消息
func showAlert(title:String, message:String){
    
    let alertController = UIAlertController(title: title,
                                            message: message, preferredStyle: .alert)
    let cancelAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
    alertController.addAction(cancelAction)
    
    UIApplication.shared.keyWindow?.rootViewController!.present(alertController, animated: true,
                                                                completion: nil)
}

func showAlert(title : String, message : String, callback : @escaping (()->())){
    let alertController = UIAlertController(title: title,
                                            message: message, preferredStyle: .alert)
    let tempAction = UIAlertAction(title: "取消", style: .cancel) { (action) in
    }
    let callAction = UIAlertAction(title: "好的", style: .default) { (action) in
        callback()
    }
    alertController.addAction(tempAction)
    alertController.addAction(callAction)
    UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
}

func HC_getTopAndBottomSpace()->(CGFloat, CGFloat){
    //兼容iPhone X
    var cutTop : CGFloat!
    var cutBottom : CGFloat!
    if #available(iOS 11.0, *) {
        if SCREEN_HEIGHT == 812 {   //iphone X
            let top = UIApplication.shared.keyWindow?.safeAreaInsets.top
            let bottom = UIApplication.shared.keyWindow?.safeAreaInsets.bottom
            cutTop = top!
            cutBottom = bottom!
        }else{
            cutTop = 20
            cutBottom = 0
        }
    } else {
        cutTop = 20
        cutBottom = 0
    }
    return (cutTop, cutBottom)
}

extension UIImageView {
    func HC_setImageFromURL(urlS : String, placeHolder : String){
        if urlS.contains("http"){
            self.sd_setImage(with: URL.init(string: urlS), placeholderImage: UIImage.init(named: placeHolder), options: .cacheMemoryOnly, completed: nil)
        }else{
            self.sd_setImage(with: URL.init(string: IMAGE_URL + urlS), placeholderImage: UIImage.init(named: placeHolder), options: .cacheMemoryOnly, completed: nil)
        }
        
    }
}


extension UIDevice {
    
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        case "iPod1,1":  return "iPod Touch 1"
        case "iPod2,1":  return "iPod Touch 2"
        case "iPod3,1":  return "iPod Touch 3"
        case "iPod4,1":  return "iPod Touch 4"
        case "iPod5,1":  return "iPod Touch (5 Gen)"
        case "iPod7,1":   return "iPod Touch 6"
            
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":  return "iPhone 4"
        case "iPhone4,1":  return "iPhone 4s"
        case "iPhone5,1":   return "iPhone 5"
        case  "iPhone5,2":  return "iPhone 5 (GSM+CDMA)"
        case "iPhone5,3":  return "iPhone 5c (GSM)"
        case "iPhone5,4":  return "iPhone 5c (GSM+CDMA)"
        case "iPhone6,1":  return "iPhone 5s (GSM)"
        case "iPhone6,2":  return "iPhone 5s (GSM+CDMA)"
        case "iPhone7,2":  return "iPhone 6"
        case "iPhone7,1":  return "iPhone 6 Plus"
        case "iPhone8,1":  return "iPhone 6s"
        case "iPhone8,2":  return "iPhone 6s Plus"
        case "iPhone8,4":  return "iPhone SE"
        case "iPhone9,1":   return "国行、日版、港行iPhone 7"
        case "iPhone9,2":  return "港行、国行iPhone 7 Plus"
        case "iPhone9,3":  return "美版、台版iPhone 7"
        case "iPhone9,4":  return "美版、台版iPhone 7 Plus"
        case "iPhone10,1","iPhone10,4":   return "iPhone 8"
        case "iPhone10,2","iPhone10,5":   return "iPhone 8 Plus"
        case "iPhone10,3","iPhone10,6":   return "iPhone X"
            
        case "iPad1,1":   return "iPad"
        case "iPad1,2":   return "iPad 3G"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":   return "iPad 2"
        case "iPad2,5", "iPad2,6", "iPad2,7":  return "iPad Mini"
        case "iPad3,1", "iPad3,2", "iPad3,3":  return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":   return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":   return "iPad Air"
        case "iPad4,4", "iPad4,5", "iPad4,6":  return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":  return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":  return "iPad Mini 4"
        case "iPad5,3", "iPad5,4":   return "iPad Air 2"
        case "iPad6,3", "iPad6,4":  return "iPad Pro 9.7"
        case "iPad6,7", "iPad6,8":  return "iPad Pro 12.9"
        case "AppleTV2,1":  return "Apple TV 2"
        case "AppleTV3,1","AppleTV3,2":  return "Apple TV 3"
        case "AppleTV5,3":   return "Apple TV 4"
        case "i386", "x86_64":   return "Simulator"
        default:  return identifier
        }
    }
}

