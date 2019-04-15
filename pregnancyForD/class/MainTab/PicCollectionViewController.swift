//
//  PicCollectionViewController.swift
//  pregnancyForD
//
//  Created by huchuang on 2018/6/13.
//  Copyright © 2018年 pg. All rights reserved.
//

import UIKit

class PicCollectionViewController: UIViewController {
    
    lazy var collectionV : UICollectionView = {
        let layout = UICollectionViewFlowLayout.init()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.itemSize = CGSize.init(width: SCREEN_WIDTH / 3, height: SCREEN_WIDTH / 3)
        let c = UICollectionView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT), collectionViewLayout: layout)
        c.dataSource = self
        c.delegate = self
        return c
    }()
    
    var clickBlock : ((Int)->())?
    
    let reuseIdentifier = "reuseIdentifier"
    
    var dataArr : [String]?{
        didSet{
            collectionV.reloadData()
        }
    }
    
    
    var totalIndex : CGFloat = 100
    var fileURLString : String = ""
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        get {
            return .lightContent
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "请选择"
        
        collectionV.register(PicCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.view.addSubview(collectionV)
        
        initData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    
    func initData(){
        var arr = [String]()
        let t = Int(totalIndex)
        for i in 1...t{
            let j = CGFloat(i)
            let urlS = getImgURLString(index: j)
            arr.append(urlS)
        }
        dataArr = arr
    }
    
    
    
    func getImgURLString(index : CGFloat) -> String{
        let i = Int(index)
        var s = String.init(format: "%d", i)
        if s.count == 1{
            s = "00" + s
        }else if s.count == 2{
            s = "0" + s
        }
        return "http://file.ivfcn.com/common-file/app/img/Embroy/" + fileURLString + "_RUN" + s + ".JPG"
    }


}


extension PicCollectionViewController: UICollectionViewDataSource, UICollectionViewDelegate{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArr?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PicCollectionViewCell
        cell.imgV.HC_setImageFromURL(urlS: dataArr![indexPath.row], placeHolder: "HC-placeHolder")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        HCPrint(message: "didSelectItemAt")
        let row = indexPath.row
        if let b = clickBlock{
            b(row + 1)
            self.navigationController?.popViewController(animated: false)
        }
    }

}
