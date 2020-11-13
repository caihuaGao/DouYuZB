//
//  CollectionViewPrettyCell.swift
//  DYZB
//
//  Created by lx on 2020/11/10.
//  Copyright © 2020 xingyuxinghua. All rights reserved.
//

import UIKit
import Kingfisher

class CollectionViewPrettyCell: UICollectionViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var cityBtn: UIButton!
    @IBOutlet weak var onlineCounLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK:- 模型属性
    var  anchor: CHAnchorModel? {
        didSet {
            guard let anchor = anchor else {return}
            
            var onlineStr: String = ""
            if anchor.online >= 10000 {
                onlineStr = "\(Int(anchor.online / 10000))万在线"
            }else {
                onlineStr = "\(Int(anchor.online / 10000))在线"
            }
            onlineCounLabel.text = onlineStr
            
            titleLabel.text = anchor.nickname
            
            cityBtn.setTitle(anchor.anchor_city, for: .normal)
            
            imgView.kf.setImage(with: URL(string: anchor.vertical_src),placeholder: UIImage(named: "Img_default"))
        }
    }

}
