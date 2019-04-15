//
//  ShowPhotoViewController.swift
//  pregnancyForD
//
//  Created by pg on 2017/5/8.
//  Copyright © 2017年 pg. All rights reserved.
//

import UIKit

class ShowPhotoViewController: UIViewController {
    
    lazy var scrollV : UIScrollView = {
        let s = UIScrollView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        return s
    }()
    
    var imagVArr : [UIImageView]?
    var scrollVArr : [UIScrollView]?
    
    var urlArr : [String]? {
        didSet{
            var tempArr = [UIImageView]()
            var tempSArr = [UIScrollView]()
            var index = 0
            for i in urlArr!{
                let url = URL.init(string: i)
                let imagV = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
                imagV.isUserInteractionEnabled = true
                imagV.isMultipleTouchEnabled = true
                imagV.contentMode = UIViewContentMode.scaleAspectFit
                imagV.HC_setImageFromURL(urlS: i, placeHolder: "HC-placeHolder")
                tempArr.append(imagV)
                
                let scrollView = UIScrollView.init(frame: CGRect.init(x: SCREEN_WIDTH * CGFloat(index), y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
                scrollView.maximumZoomScale = 2
                scrollView.minimumZoomScale = 1
                scrollView.delegate = self
                
                scrollView.addSubview(imagV)
                tempSArr.append(scrollView)
                
                scrollV.addSubview(scrollView)
                
                index = index + 1
            }
            imagVArr = tempArr
            scrollVArr = tempSArr
            
            let count = urlArr?.count
            scrollV.contentSize = CGSize.init(width: SCREEN_WIDTH * CGFloat(count!), height: 0)
        }
    }
    
    var indexBlock : ((_ i : Int)->())?
    
    //当前位置
    var index = 0 {
        didSet{
            for i in scrollVArr! {
                i.setZoomScale(1, animated: false)
            }
            
            if let block = indexBlock {
                block(index)
            }
//            let note = Notification.init(name: NSNotification.Name.init(ScrollImageV), object: nil, userInfo: ["row" : index])
//            NotificationCenter.default.post(note)
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.view.backgroundColor = UIColor.black
        
        scrollV.isPagingEnabled = true
        scrollV.delegate = self
        
        self.view.addSubview(scrollV)

        let tapGes = UITapGestureRecognizer.init(target: self, action: #selector(ShowPhotoViewController.dismissAction))
        scrollV.addGestureRecognizer(tapGes)
        
//        initSaveBtn()
        
    }
    
    func initSaveBtn(){
        let b = UIButton.init()
        b.setTitle("save", for: .normal)
        b.setTitleColor(UIColor.white, for: .normal)
        b.layer.borderColor = UIColor.white.cgColor
        b.layer.borderWidth = 1
        b.layer.cornerRadius = 5
        self.view.addSubview(b)
        b.snp.updateConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.bottom.equalTo(self.view).offset(-20)
        }
        
        b.addTarget(self, action: #selector(ShowPhotoViewController.savePic), for: .touchUpInside)
    }

    
    func savePic(){
        guard let image = imagVArr![0].image else {
            return
        }
        HCPrint(message: "savePic")
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveImage(image:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc private func saveImage(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: AnyObject) {
        var showMessage = ""
        if error != nil{
            showMessage = "保存失败"
        }else{
            showMessage = "保存成功"
        }
        HCPrint(message: showMessage)
        HCShowInfo(info: showMessage)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        scrollV.setContentOffset(CGPoint.init(x: SCREEN_WIDTH * CGFloat(index), y: 0), animated: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func dismissAction(){
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true) { 
            //
        }
    }
}

extension ShowPhotoViewController : UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //
    }
    
    //更新index
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let offsetX = scrollV.contentOffset.x
        HCPrint(message: offsetX)
        let i = offsetX / SCREEN_WIDTH
        let j = NSInteger(i)
        if index != j {
            index = j
            HCPrint(message: j)
        }
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        let offsetX = scrollV.contentOffset.x
        let i = offsetX / SCREEN_WIDTH
        let j = NSInteger(i)
        HCPrint(message: j)
        return imagVArr?[j]
    }
}
