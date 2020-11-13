//
//  CHCycleView.swift
//  DYZB
//
//  Created by lx on 2020/11/13.
//  Copyright © 2020 xingyuxinghua. All rights reserved.
//

import UIKit

private let kCellID = "CHCycleViewCellID"

class CHCycleView: UIView {

    var cycleTimer: Timer?
    
    // MARK:- 属性
    @IBOutlet weak var collocationView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    var cycleModels: [CHCycleModel]? {
        didSet {
            collocationView.reloadData()
            pageControl.numberOfPages = cycleModels?.count ?? 0
            let index = (self.cycleModels?.count ?? 1) * 100
            let indexPath = IndexPath(item: index, section: 0)
            collocationView.scrollToItem(at: indexPath, at: UICollectionView.ScrollPosition.left, animated: false)
            
            // 添加定时器
            removeCycleTime()
            addCycleTimer()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // 设置该控件不随父控件拉伸而拉伸
        autoresizingMask = []
        
        collocationView.register(UINib(nibName: "CHCycleCell", bundle: nil), forCellWithReuseIdentifier: kCellID)

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let layout = collocationView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = self.bounds.size

        
    }
    
    
}

// MARK:- 根据nib文件创建View
extension CHCycleView  {
    
    class func createCycleView() -> CHCycleView{
        
        return Bundle.main.loadNibNamed("CHCycleView", owner: nil, options: nil)?.first as! CHCycleView
    }
    
}

// MARK:- collectionDataSource
extension CHCycleView : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (self.cycleModels?.count ?? 0) * 10000
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kCellID, for: indexPath) as! CHCycleCell
        
        let index = indexPath.item % (self.cycleModels?.count ?? 1)
        cell.cycleModel = self.cycleModels?[index]
        return cell
    }

}

// MARK:- collectionDelegate
extension CHCycleView : UICollectionViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        // 设置page
        let offsetX = collocationView.contentOffset.x + collocationView.frame.width * 0.5
        pageControl.currentPage = Int(offsetX / collocationView.frame.width) % (self.cycleModels?.count ?? 1)
        
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        removeCycleTime()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        addCycleTimer()
    }

    
    
}

// MARK:- timer 的操作方法
extension CHCycleView {
    
    private func addCycleTimer(){
        cycleTimer = Timer(timeInterval: 2.5, target: self, selector: #selector(scrollToNext), userInfo: nil, repeats: true)
        RunLoop.main.add(cycleTimer!, forMode: RunLoop.Mode.common)
    }
    
    private func removeCycleTime(){
        cycleTimer?.invalidate()
        cycleTimer = nil
    }
    
    @objc func scrollToNext(){
        
        let offetX = self.collocationView.contentOffset.x + self.collocationView.frame.width
        collocationView.setContentOffset(CGPoint(x: offetX, y: 0), animated: true)
        
    }
    
    
    
}
