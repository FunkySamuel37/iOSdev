//
//  Song.swift
//  MZRadio
//
//  Created by Samuel37 on 15/10/23.
//  Copyright © 2015年 Samuel37. All rights reserved.
//

import UIKit

class Song: NSObject {
    var picture     :String!
    var albumtitle  :String!
    var file_ext    :String!
    var title       :String!
    var url         :String!
    var artist      :String!
    var length      :Int!
    
    init(picture: String, albumtitle: String, file_ext: String, title: String, url: String, artist: String, length: Int){
        self.picture    = picture
        self.albumtitle = albumtitle
        self.file_ext   = file_ext
        self.title      = title
        self.url        = url
        self.artist     = artist
        self.length     = length
    }
}
