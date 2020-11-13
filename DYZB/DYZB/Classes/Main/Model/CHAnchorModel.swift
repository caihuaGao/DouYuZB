//
//  CHAnchorModel.swift
//  DYZB
//
//  Created by lx on 2020/11/12.
//  Copyright © 2020 xingyuxinghua. All rights reserved.
//

import UIKit

@objcMembers
class CHAnchorModel: NSObject {

    /// 房间号
    var room_id: Int = 0
    /// 房间图片对应的地址
    var vertical_src: String =  ""
    ///判断电脑还是手机直播 0 电脑 1 手机
    var isVertical: Int = 0
    ///房间名称
    var room_name: String = ""
    ///主播昵称
    var nickname: String = ""
    ///观看人数
    var online: Int = 0
    /// 所在城市
    var anchor_city: String = ""
    
    init(dict:[String : NSObject]) {
        super.init()
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
    
}
