//
//  CHNetWorkTool.swift
//  DYZB
//
//  Created by lx on 2020/11/10.
//  Copyright © 2020 xingyuxinghua. All rights reserved.
//

import UIKit
import Alamofire

enum MethodType {
    case GET
    case POST
}

class CHNetworkTools {

    class func requestData(type: MethodType, urlString: String, parameters: [String:String]? = nil, finishedCallback:@escaping (_ returnData:  [NSString:AnyObject]) -> ()){
        
        // 1.获取类型
        let method = type == .GET ? HTTPMethod.get : HTTPMethod.post
        
        // 2.发送网络请求
        Alamofire.request(urlString, method: method, parameters: parameters).responseJSON { (returnData) in
            
            guard let reuslt = returnData.result.value else {
                print(returnData.result.error as Any)
                return
            }
            finishedCallback(reuslt as! [NSString : AnyObject]);
        }
        
    }
    
    
}
