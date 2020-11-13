//
//  CollectionHeaderView.swift
//  DYZB
//
//  Created by lx on 2020/11/10.
//  Copyright © 2020 xingyuxinghua. All rights reserved.
//

import UIKit

class CollectionHeaderView: UICollectionReusableView {

    // MARK:- 属性
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var group:CHAnchorGroup? {
        didSet {
            
            imageView.image = UIImage(named: group?.icon_name ?? "home_header_normal")
            titleLabel.text = group?.tag_name
            
        }
    }
    
}
