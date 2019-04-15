//
//  PicCollectionViewCell.swift
//  pregnancyForD
//
//  Created by huchuang on 2018/6/13.
//  Copyright © 2018年 pg. All rights reserved.
//

import UIKit

class PicCollectionViewCell: UICollectionViewCell {
    
    lazy var imgV : UIImageView = {
        let i = UIImageView.init()
        return i
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imgV.frame = self.bounds
        self.addSubview(imgV)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
