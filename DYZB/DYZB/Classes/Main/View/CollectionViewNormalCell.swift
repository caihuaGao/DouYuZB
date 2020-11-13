//
//  CollectionViewNormalCell.swift
//  DYZB
//
//  Created by lx on 2020/11/10.
//  Copyright © 2020 xingyuxinghua. All rights reserved.
//

import UIKit

class CollectionViewNormalCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var subTitleLabel: UILabel!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var onlineCount: UIButton!
    
    // MARK:- 模型属性
    var anchor: CHAnchorModel? {
        didSet {
            
            guard let anchor = anchor else {return}
            
            var onlineStr: String = ""
            if anchor.online >= 10000 {
                onlineStr = "\(Int(anchor.online / 10000))万在线"
            }else {
                onlineStr = "\(Int(anchor.online / 10000))在线"
            }
            onlineCount.setTitle(onlineStr, for: .normal)
            
            titleLabel.text = anchor.nickname
            
            subTitleLabel.text = anchor.room_name
                        
            imageView.kf.setImage(with: URL(string: anchor.vertical_src),placeholder: UIImage(named: "Img_default"))
            
        }
    }
    
    

}
