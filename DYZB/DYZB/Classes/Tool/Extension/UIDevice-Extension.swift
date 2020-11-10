//
//  UIDevice-Extension.swift
//  DYZB
//
//  Created by lx on 2020/11/9.
//  Copyright © 2020 xingyuxinghua. All rights reserved.
//

import UIKit

extension UIDevice {
    
    public func isiPhoneXMore() -> Bool{
        var isMore: Bool = false
        if #available(iOS 11.0,*) {
            isMore = UIApplication.shared.windows[0].safeAreaInsets.bottom > 0.0
        }
        return isMore
    }
    
}
