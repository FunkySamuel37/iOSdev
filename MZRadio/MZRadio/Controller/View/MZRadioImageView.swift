//
//  MZRadioImageView.swift
//  MZRadio
//
//  Created by Samuel37 on 15/10/16.
//  Copyright © 2015年 Samuel37. All rights reserved.
//

import UIKit

class MZRadioImageView: UIImageView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    var albumView:UIImageView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
//        self.albumView = UIImageView(frame: CGRect(x: self.frame.size.width / 2 - 80, y: self.frame.size.height / 2 - 80, width: 160, height: 160))
//        self.albumView.clipsToBounds = true//去掉超过边界的显示 
//        self.albumView.layer.cornerRadius = 80
//        self.albumView.image = UIImage(named: "Love_and_Peace")
//        self.addSubview(albumView)
    }
    
    func setupFrame(width:CGFloat, img:UIImage?){
        let albumImageWidth = width / 5 * 3
        self.albumView = UIImageView(frame: CGRect(x: (width - albumImageWidth) / 2 , y: (width - albumImageWidth) / 2, width: albumImageWidth , height: albumImageWidth))
        self.albumView.clipsToBounds = true//去掉超过边界的显示
        self.albumView.layer.cornerRadius = albumImageWidth / 2
        if img != nil {
            self.albumView.image = img
        } else {
            self.albumView.image = UIImage(named: "Love_and_Peace")

        }
        self.addSubview(albumView)
    }
    
    func startRotation(){
        
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = M_PI * 2.0
        rotateAnimation.duration = 20.0
        rotateAnimation.repeatCount = MAXFLOAT
        
        self.layer.addAnimation(rotateAnimation, forKey: "rotateAnimation")
    }
    
    func pauseRotate(){
        
        let pauseTime = self.layer.convertTime(CACurrentMediaTime(), fromLayer: nil)
        self.layer.speed = 0.0
        self.layer.timeOffset = pauseTime
        
    }
    
    func resumeRotate(){
        
        let pauseTime = self.layer.timeOffset
        self.layer.speed = 1.0
        self.layer.timeOffset = 0.0
        self.layer.beginTime = 0.0
        let timeSincePause = self.layer.convertTime(CACurrentMediaTime(), fromLayer: nil) - pauseTime
        self.layer.beginTime = timeSincePause
    }

}
