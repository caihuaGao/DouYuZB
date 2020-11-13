//
//  CHCycleCell.swift
//  DYZB
//
//  Created by lx on 2020/11/13.
//  Copyright © 2020 xingyuxinghua. All rights reserved.
//

import UIKit
import Kingfisher


class CHCycleCell: UICollectionViewCell {

    var cycleModel: CHCycleModel? {
        didSet {
            guard let cycleModel = cycleModel else {
                return
            }
            
            imageView.kf.setImage(with: URL(string: cycleModel.pic_url ?? ""),placeholder:UIImage(named: "Img_default"))
            nameLabel.text = cycleModel.title ?? ""
            
        }
    }
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
