//
//  CHRecommendVM.swift
//  DYZB
//
//  Created by lx on 2020/11/12.
//  Copyright © 2020 xingyuxinghua. All rights reserved.
//

import UIKit

class CHRecommendVM {

    // 模型属性
    lazy var anchorGroups:[CHAnchorGroup] = [CHAnchorGroup]()
    private lazy var bigDataGroup: CHAnchorGroup = CHAnchorGroup()
    private lazy var prettyGroup: CHAnchorGroup = CHAnchorGroup()
    lazy var cycleModels: [CHCycleModel] = [CHCycleModel]()

}

extension CHRecommendVM {
    
    // 请求推荐数据
    func requestData(finishCallBack:@escaping()->()) {
        
        // 0.定义相同的参数
        let paramater = ["limit": "4","offset":"0","time":NSDate.getCurrentTime()];
        
        let dGroup = DispatchGroup()
        
        // 1 请求推荐数据
        dGroup.enter()
        CHNetworkTools.requestData(type: .GET, urlString: "http://capi.douyucdn.cn/api/v1/getbigDataRoom",parameters: ["time":NSDate.getCurrentTime()]) { (result) in
            
            // 1 result 转成 字典
            guard let dataDict = result as? [String : NSObject] else {return}
            
            // 2 根基data key 获取数组
            guard let dataArray = dataDict["data"] as? [[String:NSObject]] else {return}
            
            // 3 遍历数组，获取字典，转成模型
            let group = CHAnchorGroup()
            group.tag_name = "热门"
            group.icon_name = "home_header_hot"
            for dict in dataArray {
                let anchor = CHAnchorModel(dict: dict)
                group.anchors.append(anchor)
            }
            self.bigDataGroup = group
            dGroup.leave()
            
        }
        
        
        // 2 请求颜值数据
        dGroup.enter()
        CHNetworkTools.requestData(type: .GET, urlString: "http://capi.douyucdn.cn/api/v1/getVerticalRoom",parameters: paramater) { (result) in
            
            // 1 result 转成 字典
            guard let dataDict = result as? [String : NSObject] else {return}
            
            // 2 根基data key 获取数组
            guard let dataArray = dataDict["data"] as? [[String:NSObject]] else {return}
            
            // 3 遍历数组，获取字典，转成模型
            let group = CHAnchorGroup()
            group.tag_name = "颜值"
            group.icon_name = "home_header_phone"
            for dict in dataArray {
                let anchor = CHAnchorModel(dict: dict)
                group.anchors.append(anchor)
            }
            self.prettyGroup = group
            dGroup.leave()
            
        }
        
        // 3 请求后面的数据
        // "http://capi.douyucdn.cn/api/v1/getHotCate?limit=4&offset=0&time=\(NSDate.getCurrentTime())"
        print("http://capi.douyucdn.cn/api/v1/getHotCate?limit=4&offset=0&time=\(NSDate.getCurrentTime())")
        dGroup.enter()
        CHNetworkTools.requestData(type: .POST, urlString: "http://capi.douyucdn.cn/api/v1/getHotCate",parameters: paramater) { (result) in
//            print(result)
            
            // 1 result 转成 字典
            guard let dataDict = result as? [String : NSObject] else {return}
            
            // 2 根基data key 获取数组
            guard let dataArray = dataDict["data"] as? [[String:NSObject]] else {return}
            
            // 3 遍历数组，获取字典，转成模型
            for dict in dataArray {
                let group = CHAnchorGroup(dict: dict)
                self.anchorGroups.append(group)
            }
            dGroup.leave()
            
        }
        
        dGroup.notify(queue: .main) {
            
            self.anchorGroups.insert(self.prettyGroup, at: 0)
            self.anchorGroups.insert(self.bigDataGroup, at: 0)
            
            finishCallBack()
            
        }
        
        
    }
    
    // 请求循环数据
    func requestCycleData(finishCallBack:@escaping()->()) {
        CHNetworkTools.requestData(type: .GET, urlString: "http://capi.douyucdn.cn/api/v1/slide/6",parameters: ["version":"4.300"]) { (result) in
            // 1 result 转成 字典
            guard let dataDict = result as? [String : NSObject] else {return}
            
            // 2 根基data key 获取数组
            guard let dataArray = dataDict["data"] as? [[String:NSObject]] else {return}
            
            // 3 字典转模型
            for dict in dataArray {
                let cycle = CHCycleModel(dict: dict)
                self.cycleModels.append(cycle)
            }
        
            
            finishCallBack()
        }
    }
    
    
}
