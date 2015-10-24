//
//  MusicInfo.swift
//  MZRadio
//
//  Created by Samuel37 on 15/10/24.
//  Copyright © 2015年 Samuel37. All rights reserved.
//

import UIKit

class MusicInfo {
    class var sharedInstance: MusicInfo {
        
        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: MusicInfo? = nil
        }
        
        dispatch_once(&Static.onceToken){
            Static.instance = MusicInfo()
        }
        
        return Static.instance!
    }
    
    var channelList:[Channel] = [Channel]()
}