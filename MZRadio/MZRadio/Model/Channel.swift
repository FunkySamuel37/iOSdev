//
//  Channel.swift
//  MZRadio
//
//  Created by Samuel37 on 15/10/23.
//  Copyright © 2015年 Samuel37. All rights reserved.
//

import UIKit

class Channel: NSObject {
    
    var name_en     :String?
    var seq_id      :Int!
    var abbr_en     :String?
    var name        :String!
    var channel_id  :Int!
    
    init(channel_id:Int, name:String, seq_id:Int, abbr_en:String?, name_en:String?){
        
        self.channel_id = channel_id
        self.name = name
        self.seq_id = seq_id
        self.abbr_en = abbr_en
        self.name_en = name_en
    }
}
