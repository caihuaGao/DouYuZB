//
//  CHAnchorGroup.swift
//  DYZB
//
//  Created by lx on 2020/11/12.
//  Copyright © 2020 xingyuxinghua. All rights reserved.
//

import UIKit

@objcMembers
class CHAnchorGroup: NSObject {
    
    // 房间信息
    var room_list: [[NSString : NSObject]]? {
        didSet {
            guard let list_room = room_list else {return}
            for dict in list_room {
                let d = dict as [String : NSObject]
                anchors.append(CHAnchorModel.init(dict: d))
            }
        }
    }
    // 组标题
    var tag_name: String = ""
    // 组图片
    var icon_name: String = "home_header_normal"
    //
    // 组图片
    var icon_url: String = ""
    
    lazy var anchors: [CHAnchorModel] = [CHAnchorModel]()
    
    init(dict:[String : NSObject]){
        super.init()
        setValuesForKeys(dict)
    }
    
    override init() {
        
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
    
    
    
}
