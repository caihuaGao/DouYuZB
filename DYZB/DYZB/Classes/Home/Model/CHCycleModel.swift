//
//  CHCycleModel.swift
//  DYZB
//
//  Created by lx on 2020/11/13.
//  Copyright © 2020 xingyuxinghua. All rights reserved.
//

import UIKit

@objcMembers
class CHCycleModel: NSObject {

    /// 标题
    var title: String? = ""
    /// 展示图片地址
    var pic_url: String? = ""
    /// 主播信息对应的字典
    var room:[String : NSObject]? {
        didSet {
            guard let room = room else {return}
            anchor = CHAnchorModel(dict: room)
        }
    }
    /// 主播信息对应的对象
    var anchor: CHAnchorModel?
    
    // MARK:- 自动以构造函数
    init(dict: [String : NSObject]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
}
