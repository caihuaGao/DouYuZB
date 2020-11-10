//
//  CHPageContentView.swift
//  DYZB
//
//  Created by lx on 2020/11/9.
//  Copyright © 2020 xingyuxinghua. All rights reserved.
//

import UIKit

protocol CHPageContentViewDelegate : class{
    func pageContentView(contentView:CHPageContentView,progress: CGFloat, sourseIndex: Int, targetIndex: Int)
}

private let contentCellID = "contentCellID"

class CHPageContentView: UIView {

    private var childVcs:[UIViewController]
    private weak var presentViewController:UIViewController?
    private var startOffset: CGFloat = 0
    weak var delegate:CHPageContentViewDelegate?
    private var isForbidScrolldelegate: Bool = false
    private lazy var collectionView: UICollectionView = { [weak self] in
       
        // 1
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = (self?.bounds.size)!
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        
        // 2
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.bounces = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: contentCellID)
        return collectionView
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(frame: CGRect, childVcs:[UIViewController],presentVC:UIViewController?) {
        
        self.childVcs = childVcs
        self.presentViewController = presentVC
        super.init(frame:frame)
        
        // 设置UI
        setupUI()
        
    }
    
    
}

// MARK:- 设置UI
extension CHPageContentView {
    
    private func setupUI(){
        // 将所有的子控制器添加到父控制器
        for childVc in childVcs {
            presentViewController?.addChild(childVc)
        }
        
        // 添加collocationView
        addSubview(collectionView)
        collectionView.frame = self.bounds
    }
    
}

// MARK:- collection datasource
extension CHPageContentView :UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childVcs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: contentCellID, for: indexPath)
        
        let childVc = childVcs[indexPath.row]
        
        for view in cell.contentView.subviews {
            view.removeFromSuperview()
        }
        childVc.view.frame = cell.bounds
        cell.addSubview(childVc.view)
        return cell
    }
    
}

// MARK:- collection delegate
extension CHPageContentView: UICollectionViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        startOffset = scrollView.contentOffset.x
        isForbidScrolldelegate = false
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        // 点击不用调用代理
        if isForbidScrolldelegate {return}
        
        // 1 定义需要的数据
        var progress: CGFloat = 0
        var sourceIndex: Int = 0
        var targetIndex: Int = 0
        
        // 判断左右滑动
        let currentOffsetX = scrollView.contentOffset.x
        let scrollViewW = scrollView.bounds.width
        if currentOffsetX > startOffset { //往左滑
            // 1
            progress = currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW)
            // 2
            sourceIndex = Int(currentOffsetX / scrollViewW)
            // 3
            targetIndex = sourceIndex + 1
            if targetIndex >= childVcs.count {
                targetIndex = childVcs.count - 1
            }
            // 4
            if currentOffsetX - startOffset == scrollViewW {
                progress = 1
                targetIndex = sourceIndex
            }
            
        }else{ // 往右划
            // 1
            progress = 1 - (currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW))

            // 2
            targetIndex = Int(currentOffsetX / scrollViewW)
            
            // 3
            sourceIndex = targetIndex + 1
            if sourceIndex >= childVcs.count {
                sourceIndex = childVcs.count - 1
            }
            
        }
        
        // 通知titleView
        self.delegate?.pageContentView(contentView: self, progress: progress, sourseIndex: sourceIndex, targetIndex: targetIndex)
        
        
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
}

// MARK:- 对外暴露的方法
extension CHPageContentView {
    
    func setCurrentIndex(currentIndex:Int){
        
        isForbidScrolldelegate = true
        collectionView.contentOffset.x = CGFloat(currentIndex) * collectionView.frame.width
        
    }
    
    
}
