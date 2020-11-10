//
//  UIColor-Extentsion.swift
//  DYZB
//
//  Created by lx on 2020/11/9.
//  Copyright © 2020 xingyuxinghua. All rights reserved.
//

import UIKit

extension UIColor {
        
    convenience init(r:CGFloat,g:CGFloat,b:CGFloat) {
        self.init(red: r/255.0,green: g/255.0,blue: b/255.0,alpha:1.0)
    }
    
    
    
    class func random() -> UIColor{
        return UIColor(red: CGFloat(arc4random_uniform(255))/255.0, green: CGFloat(arc4random_uniform(255))/255.0, blue: CGFloat(arc4random_uniform(255))/255.0, alpha: 1.0)
    }
    
}
