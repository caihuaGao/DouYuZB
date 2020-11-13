//
//  RecommendViewController.swift
//  DYZB
//
//  Created by lx on 2020/11/10.
//  Copyright © 2020 xingyuxinghua. All rights reserved.
//

import UIKit

private let kItemMargin:CGFloat = 10
private let kItemW: CGFloat = (kScreenW - 3*kItemMargin) / 2
private let kItemNormalH: CGFloat = kItemW * 3 / 4
private let kItemPrettyH: CGFloat = kItemW * 4 / 3
private let kHeaderH: CGFloat = 50
private let kCycleViewH: CGFloat = kScreenW * 3 / 8
private let kGameViewH: CGFloat = 90

private let kHeaderViewID: String = "kHeaderViewID"
private let kNormalCellID: String = "kNormalCellID"
private let kPrettyCellID: String = "kPrettyCellID"


class RecommendViewController: UIViewController {

    
    
    // MARK:- 懒加载属性
    private lazy var recommendVM: CHRecommendVM = {
       let recommendVM = CHRecommendVM()
        return recommendVM;
    }()

    private lazy var collectionView:UICollectionView = {
       let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = kItemMargin
        layout.itemSize = CGSize(width: kItemW, height: kItemNormalH)
        layout.headerReferenceSize = CGSize(width: kScreenW, height: kHeaderH)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        
        let collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.autoresizingMask = [.flexibleWidth,.flexibleHeight]

        collectionView.register(UINib(nibName: "CollectionViewNormalCell", bundle: nil), forCellWithReuseIdentifier: kNormalCellID)
        collectionView.register(UINib(nibName: "CollectionViewPrettyCell", bundle: nil), forCellWithReuseIdentifier: kPrettyCellID)
        collectionView.register(UINib(nibName: "CollectionHeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: kHeaderViewID)
        
        return collectionView
    }()
    
    private lazy var cycleView:CHCycleView = {
        let cycleView = CHCycleView.createCycleView()
        cycleView.frame = CGRect(x: 0, y: -(kCycleViewH + kGameViewH), width: kScreenW, height: kCycleViewH)
        return cycleView
    }()
    
    private lazy var gameView: CHGameView = {
        let gameView = CHGameView.cretateGameView()
        gameView.frame = CGRect(x: 0, y: -kGameViewH, width: kScreenW, height: kGameViewH)
        return gameView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.random()
        
        setupUI()
        
        loadData();
    }



}

// MARK:- 请求数据
extension RecommendViewController {
    
    func loadData(){
        // 推荐数据
        self.recommendVM.requestData {
            self.collectionView.reloadData()
            self.gameView.groups = self.recommendVM.anchorGroups
        };
        
        // 轮播数据
        self.recommendVM.requestCycleData {
            self.cycleView.cycleModels = self.recommendVM.cycleModels
        }
        
    }
}

// MARK:- 设置UI界面
extension RecommendViewController {
    
    func setupUI() {
        
        self.view.addSubview(collectionView)
        
        // 添加循环数据
        self.collectionView.addSubview(self.cycleView)
        
        
        // 设置collentionView的内边距
        self.collectionView.contentInset = UIEdgeInsets(top: (kCycleViewH + kGameViewH), left: 0, bottom: 0, right: 0)
        
        self.collectionView.addSubview(self.gameView)
    }
    
}

// MARK:- collectionDatasource
extension RecommendViewController :UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.recommendVM.anchorGroups.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let group = self.recommendVM.anchorGroups[section]
        return group.anchors.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let group = self.recommendVM.anchorGroups[indexPath.section]
        let anchor = group.anchors[indexPath.item]
        
        if indexPath.section == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kPrettyCellID, for: indexPath) as! CollectionViewPrettyCell
            cell.anchor = anchor
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kNormalCellID, for: indexPath) as! CollectionViewNormalCell
            cell.anchor = anchor
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: kHeaderViewID, for: indexPath) as! CollectionHeaderView
        let group = self.recommendVM.anchorGroups[indexPath.section]
        reusableView.group = group
        return reusableView
    }
    
}

// MARK:- collectionDelegaet
extension RecommendViewController :UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.section == 1 {
            return CGSize(width: kItemW, height: kItemPrettyH)
        }else{
            return CGSize(width: kItemW, height: kItemNormalH)
        }
        
    }
    
    
}
