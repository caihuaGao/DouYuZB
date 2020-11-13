//
//  Date-Extension.swift
//  DYZB
//
//  Created by lx on 2020/11/11.
//  Copyright © 2020 xingyuxinghua. All rights reserved.
//

import Foundation

extension NSDate {
    
    class func getCurrentTime() -> String{
        
        let date = NSDate()
        
        return "\(Int(date.timeIntervalSince1970))"
        
        
    }
    
}
