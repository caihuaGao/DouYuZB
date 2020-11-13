//
//  HomeViewController.swift
//  DYZB
//
//  Created by lx on 2020/11/6.
//  Copyright © 2020 xingyuxinghua. All rights reserved.
//

import UIKit

private let kTitleViewH:CGFloat = 40

class HomeViewController: UIViewController {

    
    // MARK:- 懒加载属性
    private lazy var recommendVM: CHRecommendVM = {
       let recommendVM = CHRecommendVM()
        return recommendVM;
    }()
    
    private lazy var pageTitleView: CHPageTitleView = {
        let titleFrame = CGRect(x: 0, y: kNavigationBarH, width: kScreenW, height: kTitleViewH)
        let titles = ["推荐","游戏","娱乐","趣玩"]
        let titleView = CHPageTitleView(frame: titleFrame, titles: titles)
        titleView.delegate = self
        return titleView
    }()
    
    private lazy var pageContentView: CHPageContentView = {
       let contentViewH = kScreenH - kNavigationBarH - kTitleViewH - kTabBarH
        let contViewFrame = CGRect(x: 0, y: kNavigationBarH + kTitleViewH, width: kScreenW, height: contentViewH)
        var childVcs: [UIViewController] = [UIViewController]()
        
        let recommendVC = RecommendViewController()
        childVcs.append(recommendVC)
        
        for _ in 0..<3 {
            let vc = UIViewController()
            vc.view.backgroundColor = UIColor.random()
            childVcs.append(vc)
        }
        
        let contentView = CHPageContentView(frame: contViewFrame, childVcs: childVcs, presentVC: self)
        contentView.delegate = self
        return contentView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 设置UI界面
        setupUI()
        
    }

}

extension HomeViewController {
    
    private func setupUI(){
        
        // 0.不需要调整导航栏的内边距
//        automaticallyAdjustsScrollViewInsets = false
        
        // 1.设置导航栏
        setNavigationBar()
        
        // 2.添加TitleView
        view.addSubview(pageTitleView)
        
        // 添加ContentView
        view.addSubview(pageContentView)
        pageContentView.backgroundColor = UIColor.purple
    }
    
    private func setNavigationBar(){
        
        // 左边按钮
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "logo")
        
        // 右边按钮
        let size = CGSize(width: 40, height: 40)
        
        let historyItem = UIBarButtonItem(imageName: "image_my_history", highImageName: "Image_my_history_click", size: size)
        let searchItem = UIBarButtonItem(imageName: "btn_search", highImageName: "btn_search_clicked", size: size)
        let qrcodeItem = UIBarButtonItem(imageName: "Image_scan", highImageName: "Image_scan_click", size: size)
        
        navigationItem.rightBarButtonItems = [historyItem,searchItem,qrcodeItem]
        
    }

}

// MARK:- PageTitleViewDelegate
extension HomeViewController: CHPageTitleViewDelegate {
    
    func chpageTitleView(titleView: CHPageTitleView, selectedIndex index: Int) {
        
        self.pageContentView.setCurrentIndex(currentIndex: index)
        
    }
    
}

// MARK:- CHPageContentViewDelegate
extension HomeViewController: CHPageContentViewDelegate {
    
    func pageContentView(contentView: CHPageContentView, progress: CGFloat, sourseIndex: Int, targetIndex: Int) {
        self.pageTitleView.setLableIndex(progress: progress, sourseIndex: sourseIndex, targetIndex: targetIndex)
    }
    
}
