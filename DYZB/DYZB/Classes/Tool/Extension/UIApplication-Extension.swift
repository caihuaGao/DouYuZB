//
//  UIApplication-Extension.swift
//  DYZB
//
//  Created by lx on 2020/11/9.
//  Copyright © 2020 xingyuxinghua. All rights reserved.
//

import UIKit

//extension UIApplication {
//    
//    var currentWindow: UIWindow? {
//        
//        if #available(iOS 13.0, *) {
//            
//            if let window = connectedScenes
//                .filter({$0.activationState == .foregroundActive})
//                .map({$0 as? UIWindowScene})
//                .compactMap({$0})
//                .first?
//                .windows.filter({$0.isKeyWindow}).first {
//                return window
//            }else if let window = UIApplication.shared.delegate?.window{
//                return window
//            }else {
//                return nil
//            }
//        }else{
//            if let window = UIApplication.shared.delegate?.window {
//                return window
//            }else {
//                return nil
//            }
//        }
//        
//    }
//    
//}

extension UIApplication {
    var currentWindow: UIWindow? {
        if #available(iOS 13.0, *) {
            if let window = connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .map({$0 as? UIWindowScene})
                .compactMap({$0})
                .first?.windows
                .filter({$0.isKeyWindow}).first{
                return window
            }else if let window = UIApplication.shared.delegate?.window{
                return window
            }else{
                return nil
            }
        } else {
            if let window = UIApplication.shared.delegate?.window{
                return window
            }else{
                return nil
            }
        }
    }
}
