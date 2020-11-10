//
//  UIBarButtonItem-Extension.swift
//  DYZB
//
//  Created by lx on 2020/11/9.
//  Copyright © 2020 xingyuxinghua. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
       
    // 添加遍历构造器
    convenience init(imageName : String, highImageName : String = "", size : CGSize = CGSize.zero) {
        // 创建button
        let btn = UIButton()
        
        // 设置按钮不同状态图片
        btn.setImage( UIImage(named: imageName), for: UIControl.State.normal)
        if highImageName != "" {
            btn.setImage(UIImage(named: highImageName), for: UIControl.State.highlighted)
        }
        
        // 设置按钮大小
        if size == CGSize.zero {
            btn.sizeToFit()
        }else{
            btn.frame = CGRect(origin: CGPoint.zero, size: size)
        }
        
        // 调用构造方法
        self.init(customView:btn)
        
    }
    
}

