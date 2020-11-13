//
//  CHGameCell.swift
//  DYZB
//
//  Created by lx on 2020/11/13.
//  Copyright © 2020 xingyuxinghua. All rights reserved.
//

import UIKit
import Kingfisher

class CHGameCell: UICollectionViewCell {

    var group:CHAnchorGroup? {
        didSet {
            guard let group = group else {
                return
            }
            imgView.kf.setImage(with: URL(string: group.icon_url),placeholder: UIImage(named: "home_more_btn"))
            titleLabel.text = group.tag_name
        }
    }
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
