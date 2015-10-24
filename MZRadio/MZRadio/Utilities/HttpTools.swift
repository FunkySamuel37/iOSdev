//
//  HttpTools.swift
//  MZRadio
//
//  Created by Samuel37 on 15/10/23.
//  Copyright © 2015年 Samuel37. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class HttpTool {
    
    class var sharedInstance: HttpTool {
        
        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: HttpTool? = nil
        }
        
        dispatch_once(&Static.onceToken){
            Static.instance = HttpTool()
        }
        
        return Static.instance!
    }
    
    private func getRequest(url: String, parameters: [String: AnyObject]?, completionHandler: ( NSData?, NSError?) -> Void){
        Alamofire.request(.GET, NetInfo.WEB_SERVER + url, parameters: parameters, encoding: ParameterEncoding.URL).response { (req, _, data, error) -> Void in
//            print("\(req)")
            completionHandler(data, error)
        }
    }
    
    
    func getChannel(completionHandler: (channels: [Channel]) -> Void){
        self.getRequest(NetInfo.GET_CHANNEL_INFO, parameters: nil) { (data, error) -> Void in
            if error == nil {
//                print(NSString(data: data as NSData!, encoding: NSUTF8StringEncoding))
        
                let json = JSON(data: data as NSData!)
                let channelsJSON = json["channels"]
                var channelsArray = [Channel]()
                for i in 0..<channelsJSON.count {
//                    print(i)
                    let channel_id = channelsJSON[i]["channel_id"]
                    let name = channelsJSON[i]["name"]
                    let seq_id = channelsJSON[i]["seq_id"]
                    let abbr_en = channelsJSON[i]["abbr_en"]
                    let name_en = channelsJSON[i]["name_en"]
                    
                    let channel = Channel(channel_id: channel_id.intValue, name: name.string!, seq_id: seq_id.intValue, abbr_en: abbr_en.string, name_en: name_en.string)
                    channelsArray.append(channel)
                }
                completionHandler(channels: channelsArray)
            }
        }
    }
    
    func getSong(channel_id:Int, completionHandler: (song: Song) -> Void){
        self.getRequest(NetInfo.GET_PLAYLIST, parameters: ["channel":channel_id]) { (data, error) -> Void in
//            print(NSString(data: data as NSData!, encoding: NSUTF8StringEncoding))
            if error == nil {
                let json = JSON(data: data as NSData!)
                let song = json["song"][0]
                let picture = song["picture"].string
                let albumtitle = song["albumtitle"].string
                let file_ext = song["file_ext"].string
                let title = song["title"].string
                let url = song["url"].string
                let artist = song["artist"].string
                let length = song["length"].intValue
                
                let mySong = Song(picture: picture!, albumtitle: albumtitle!, file_ext: file_ext!, title: title!, url: url!, artist: artist!, length: length)
                completionHandler(song: mySong)
            }
        }
    }
    
//    func getPlaylist(channel_id:Int, completionHandler: (playList: [song]) -> Void)
    
}
