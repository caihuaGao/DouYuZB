//
//  CHGameView.swift
//  DYZB
//
//  Created by lx on 2020/11/13.
//  Copyright © 2020 xingyuxinghua. All rights reserved.
//

import UIKit

private let kGameCellID = "kGameCellID"
class CHGameView: UIView {

    @IBOutlet weak var collectionView: UICollectionView!
    var groups:[CHAnchorGroup]? {
        didSet {
            groups?.removeFirst()
            groups?.removeFirst()
            
            // 添加更多
            let moreGroup:CHAnchorGroup = CHAnchorGroup()
            moreGroup.tag_name = "更多"
            groups?.append(moreGroup)
            
            collectionView.reloadData()
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        autoresizingMask = []
        collectionView.register(UINib(nibName: "CHGameCell", bundle: nil), forCellWithReuseIdentifier: kGameCellID)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)

    }

}
// MARK:- 创建该控件
extension CHGameView  {
    class func cretateGameView() -> CHGameView{
        return Bundle.main.loadNibNamed("CHGameView", owner: nil, options: nil)?.first as! CHGameView
    }
}

// MARK:- collectionView datasource
extension CHGameView : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return groups?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "kGameCellID", for: indexPath) as! CHGameCell
        cell.group = groups?[indexPath.item]
        return cell
    }
    
}
