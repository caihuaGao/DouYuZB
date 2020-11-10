//
//  CHPageTitleView.swift
//  DYZB
//
//  Created by lx on 2020/11/9.
//  Copyright © 2020 xingyuxinghua. All rights reserved.
//

import UIKit
// MARK:- 定义协议
protocol CHPageTitleViewDelegate :class {
    func chpageTitleView(titleView: CHPageTitleView, selectedIndex index: Int)
}
// MARK:- 定义常量
private let kScrollLineH: CGFloat = 2.0
private let kNormalColor: (CGFloat,CGFloat,CGFloat) = (85,85,85)
private let kSelectedColor: (CGFloat,CGFloat,CGFloat) = (255,128,0)

class CHPageTitleView: UIView {

    // 定义属性
    private var titles: [String]
    private var currentIndex: Int = 0
    weak var delegate: CHPageTitleViewDelegate?
    
    private lazy var titleLabels: [UILabel] = [UILabel]()
    
    // MARK:- 懒加载属性
    private lazy var scrollView:UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.scrollsToTop = false
        scrollView.bounces = false
        return scrollView
    }()
    
    private lazy var scrollLine: UIView = {
        let scrollLine = UIView()
        scrollLine.backgroundColor = UIColor.orange
        return scrollLine
    }()
    
    init(frame: CGRect , titles: [String]) {
        
        self.titles = titles
        super.init(frame: frame)
        
        setupUI()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

extension CHPageTitleView {
    
    private func setupUI(){
    
        // 1 添加scrollView
        addSubview(scrollView)
        scrollView.frame = self.bounds
        scrollView.contentInsetAdjustmentBehavior = .never
        
        // 2 添加对应的Label
        setupTitleLabels()
        
        // 3 添加下划线
        setupLine()
    }
    
    private func setupTitleLabels(){
        
        // 计算label的frame
        let labelW: CGFloat = frame.width / CGFloat(titles.count)
        let labelH: CGFloat = frame.height - kScrollLineH
        let labelY: CGFloat = 0
        
        for (index,title) in titles.enumerated() {
            let label = UILabel()
            label.text = title
            label.textColor = UIColor(r: kNormalColor.0, g: kNormalColor.1, b: kNormalColor.2)
            label.font = UIFont.systemFont(ofSize: 16.0)
            label.textAlignment = .center
            label.tag = index
            
            let labelX = labelW * CGFloat(index)
            label.frame = CGRect(x: labelX, y: labelY, width: labelW, height: labelH)
            
            scrollView.addSubview(label)
            
            titleLabels.append(label)
            
            label.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.titleLabelClick(tapGes:)))
            label.addGestureRecognizer(tap)
        }
        
        // 第一个默认颜色
        let label = titleLabels.first
        label?.textColor = UIColor(r: kSelectedColor.0, g: kSelectedColor.1, b: kSelectedColor.2)
        
    }
    
    private func setupLine(){
        
        let bottomLine = UIView()
        bottomLine.backgroundColor = UIColor.lightGray
        bottomLine.frame = CGRect(x: 0, y: frame.height-0.5, width: frame.width, height: 0.5)
        addSubview(bottomLine)
        
        scrollView.addSubview(scrollLine)
        guard let firstLabel = titleLabels.first else {
            return
        }
        scrollLine.frame = CGRect(x: firstLabel.frame.origin.x, y: frame.height-kScrollLineH, width: firstLabel.frame.width, height: kScrollLineH)
        
        
    }
    
}

// MARK:- 对外暴露的方法
extension CHPageTitleView {
    
    func setLableIndex(progress: CGFloat, sourseIndex: Int, targetIndex: Int){
        //1 取出label
        let sourceLabel = titleLabels[sourseIndex];
        let targetLabel = titleLabels[targetIndex];
        
        //2 处理滑块逻辑
        let moveX = (targetLabel.frame.origin.x - sourceLabel.frame.origin.x) * progress
        scrollLine.frame.origin.x = sourceLabel.frame.origin.x + moveX
        
        //3 颜色的渐变 使用RGB值做渐变
        // 取出变化的范围
        let colorDelta = (kSelectedColor.0-kNormalColor.0,kSelectedColor.1-kNormalColor.1,kSelectedColor.2-kNormalColor.2)
        // 选中颜色 -> 正常的颜色
        sourceLabel.textColor = UIColor(r: kSelectedColor.0 - colorDelta.0 * progress, g: kSelectedColor.1 - colorDelta.1 * progress, b: kSelectedColor.2 - colorDelta.2 * progress)
        // 正常颜色 -> 选中颜色
        targetLabel.textColor = UIColor(r: kNormalColor.0 + colorDelta.0 * progress, g: kNormalColor.1 + colorDelta.1 * progress, b: kNormalColor.2 + colorDelta.2 * progress)
        
        //4 记录最新的index
        currentIndex = targetIndex
    }
    
    
}

// MARK:- 监听点击
extension CHPageTitleView {
    
    @objc private func titleLabelClick(tapGes: UITapGestureRecognizer){
        
        // 1 获取当前lable 和 上次的lable
        guard let currentLabel = tapGes.view as? UILabel else {return}
        let oldLabel = titleLabels[currentIndex]
        
        // 2 更换颜色
        currentLabel.textColor = UIColor(r: kSelectedColor.0, g: kSelectedColor.1, b: kSelectedColor.2)
        oldLabel.textColor = UIColor(r: kNormalColor.0, g: kNormalColor.1, b: kNormalColor.2)
        
        //记住当前点击的
        currentIndex = currentLabel.tag
        
        // 滑动滚动条
        let scrollLineX = CGFloat(currentIndex) * currentLabel.frame.width
        UIView.animate(withDuration: 0.25) {
            self.scrollLine.frame.origin.x = scrollLineX
        }
        
        // 通知代理做事
        delegate?.chpageTitleView(titleView: self, selectedIndex: currentIndex)
    }
    
}
