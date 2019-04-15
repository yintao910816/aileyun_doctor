//
//  ShowPicturesViewController.swift
//  pregnancyForD
//
//  Created by huchuang on 2018/6/8.
//  Copyright © 2018年 pg. All rights reserved.
//

import UIKit

class ShowPicturesViewController: UIViewController {

    lazy var scrollV : UIScrollView = {
        let s = UIScrollView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        return s
    }()
    
    lazy var currentImgV : UIImageView = {
        let imagV = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        imagV.isUserInteractionEnabled = true
        imagV.isMultipleTouchEnabled = true
        imagV.contentMode = UIViewContentMode.scaleAspectFit
        return imagV
    }()
    
    lazy var nextImgV : UIImageView = {
        let imagV = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        imagV.isUserInteractionEnabled = true
        imagV.isMultipleTouchEnabled = true
        imagV.contentMode = UIViewContentMode.scaleAspectFit
        return imagV
    }()
    
    lazy var currentImgScrollV : UIScrollView = {
        let scrollView = UIScrollView.init(frame: CGRect.init(x: SCREEN_WIDTH, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        scrollView.maximumZoomScale = 2
        scrollView.minimumZoomScale = 1
        scrollView.delegate = self
        return scrollView
    }()
    
    lazy var nextImgScrollV : UIScrollView = {
        let scrollView = UIScrollView.init(frame: CGRect.init(x: SCREEN_WIDTH * 2, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        scrollView.maximumZoomScale = 2
        scrollView.minimumZoomScale = 1
        scrollView.delegate = self
        return scrollView
    }()
    
    lazy var progressV : UIProgressView = {
        let p = UIProgressView.init(progressViewStyle: UIProgressViewStyle.default)
        p.progressTintColor = kDefaultThemeColor
        p.backgroundColor = kLightGrayColor
        return p
    }()
    
    lazy var progressL : UILabel = {
        let l = UILabel.init()
        l.textColor = UIColor.white
        l.textAlignment = .center
        return l
    }()
    
    
    var currentIndex : CGFloat = 1{
        didSet{
            let p = currentIndex / totalIndex
            progressV.setProgress(Float(p), animated: false)
            progressL.text = String.init(format: "%0.f / %0.f", currentIndex, totalIndex)
        }
    }
    
    var nextIndex : CGFloat = 2
    
    var totalIndex : CGFloat = 100
    var fileURLString : String = ""
    
    var direction : Direction = .DirectionNone {  //滚动方向
        //设置新值之前
        willSet {
            if newValue == direction {
                return
            }
        }
        //设置新值之后
        didSet {
            //向右滚动
            if direction == .DirectionRight{
                if nextImgScrollV.frame != CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT){
                    nextImgScrollV.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
                    nextIndex = currentIndex - 1
                    if nextIndex == 0{
                        nextIndex = totalIndex
                    }
                    nextImgV.HC_setImageFromURL(urlS: getImgURLString(index: nextIndex), placeHolder: "HC-placeHolder")
                }
            }
            //向左滚动
            if direction == .DirectionLeft{
                if nextImgScrollV.frame != CGRect(x: SCREEN_WIDTH * 2, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT){
                    nextImgScrollV.frame = CGRect(x: SCREEN_WIDTH * 2, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
                    nextIndex = currentIndex + 1
                    if nextIndex > totalIndex{
                        nextIndex = 1
                    }
                    nextImgV.HC_setImageFromURL(urlS: getImgURLString(index: nextIndex), placeHolder: "HC-placeHolder")
                }
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        
        initUI()
        
        let tapGes = UITapGestureRecognizer.init(target: self, action: #selector(ShowPhotoViewController.dismissAction))
        scrollV.addGestureRecognizer(tapGes)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    
    func initUI(){
        self.view.backgroundColor = UIColor.black
        
        scrollV.isPagingEnabled = true
        scrollV.delegate = self
        
        self.view.addSubview(scrollV)
        
        currentImgScrollV.addSubview(currentImgV)
        nextImgScrollV.addSubview(nextImgV)
        
        scrollV.addSubview(currentImgScrollV)
        scrollV.addSubview(nextImgScrollV)
        
        scrollV.contentSize = CGSize.init(width: SCREEN_WIDTH * 3, height: 0)
        scrollV.contentOffset = CGPoint.init(x: SCREEN_WIDTH, y: 0)
        
        currentIndex = 1
        nextIndex = 2
        
        currentImgV.HC_setImageFromURL(urlS: getImgURLString(index: currentIndex), placeHolder: "HC-placeHolder")
        nextImgV.HC_setImageFromURL(urlS: getImgURLString(index: nextIndex), placeHolder: "HC-placeHolder")
        
        //进度
        let progressC = UIView.init(frame: CGRect.init(x: 0, y: SCREEN_HEIGHT - 40, width: SCREEN_WIDTH, height: 30))
        progressC.addSubview(progressL)
        progressL.snp.updateConstraints { (make) in
            make.right.equalTo(progressC).offset(-10)
            make.top.bottom.equalTo(progressC)
            make.width.equalTo(80)
        }
        
        progressC.addSubview(progressV)
        progressV.snp.updateConstraints { (make) in
            make.left.equalTo(progressC).offset(10)
            make.centerY.equalTo(progressC)
            make.right.equalTo(progressL.snp.left)
        }
        
        self.view.addSubview(progressC)
        
        let videoBtn = UIButton.init(frame: CGRect.init(x: 10, y: 10, width: 40, height: 35))
        videoBtn.addTarget(self, action: #selector(showVideoV), for: .touchUpInside)
        videoBtn.setTitle("视频", for: .normal)
        
        self.view.addSubview(videoBtn)
        
        
        let colBtn = UIButton.init(frame: CGRect.init(x: SCREEN_WIDTH - 60, y: 10, width: 40, height: 35))
        colBtn.addTarget(self, action: #selector(showPicCollectV), for: .touchUpInside)
        colBtn.setTitle("选择", for: .normal)
        
        self.view.addSubview(colBtn)
    }
    
    
    func showVideoV(){
        self.navigationController?.pushViewController(ShowVideoViewController(), animated: true)
    }
    
    func showPicCollectV(){
        let pVC = PicCollectionViewController()
        pVC.totalIndex = totalIndex
        pVC.fileURLString = fileURLString
        pVC.clickBlock = {[weak self](i)in
            self?.currentIndex = CGFloat(i)
            self?.currentImgV.HC_setImageFromURL(urlS: (self?.getImgURLString(index: CGFloat(i)))!, placeHolder: "HC-placeHolder")
        }
        self.navigationController?.pushViewController(pVC, animated: true)
    }
    
    
    func getImgURLString(index : CGFloat) -> String{
        let i = Int(index)
        var s = String.init(format: "%d", i)
        if s.count == 1{
            s = "00" + s
        }else if s.count == 2{
            s = "0" + s
        }
        s = "http://file.ivfcn.com/common-file/app/img/Embroy/" + fileURLString + "_RUN" + s + ".JPG"
        HCPrint(message: s)
        return s
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func dismissAction(){
        self.navigationController?.popViewController(animated: true)
    }
}

extension ShowPicturesViewController : UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        if scrollView == currentImgScrollV{
            return currentImgV
        }else{
            return nextImgV
        }
    }
    
    
    //MARK: -----UIScrollViewDelegate-----
    func scrollViewDidScroll(_ scrollView: UIScrollView){
        let offsetX = scrollView.contentOffset.x;
        self.direction = offsetX > SCREEN_WIDTH ? .DirectionLeft : offsetX < SCREEN_WIDTH ? .DirectionRight : .DirectionNone
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView){
        self.pauseScroll()
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView){
        self.pauseScroll()
    }
    
    ///停止滚动
    func pauseScroll(){
        
        currentImgScrollV.setZoomScale(1, animated: false)
        nextImgScrollV.setZoomScale(1, animated: false)
        
        let offset = self.scrollV.contentOffset.x;
        let index = offset / SCREEN_WIDTH
        //1表示没有滚动
        if index == 1{
            return
        }
        
        currentIndex = self.nextIndex
        
        //交换scrollView位置
        let tempV = currentImgScrollV
        currentImgScrollV = nextImgScrollV
        nextImgScrollV = tempV
        
        //交换imgV指针
        let tempImgV = currentImgV
        currentImgV = nextImgV
        nextImgV = tempImgV
        
        scrollV.bringSubview(toFront: currentImgScrollV)
        currentImgScrollV.frame = CGRect(x: SCREEN_WIDTH, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        scrollV.contentOffset = CGPoint(x: SCREEN_WIDTH, y: 0)
    }
}
