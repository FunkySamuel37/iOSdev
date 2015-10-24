//
//  CenterViewController.swift
//  MZRadio
//
//  Created by Samuel37 on 15/10/16.
//  Copyright © 2015年 Samuel37. All rights reserved.
//

import UIKit
import SDWebImage


class CenterViewController: UIViewController, ChannelSelectProtocol {
    
    
    @IBOutlet weak var buttonPlayorPause: UIButton!
    let screenSize = UIScreen.mainScreen().bounds
    var isRotating: Bool = false
    var needleOriginTransform: CGAffineTransform!
    @IBOutlet weak var albumImageView: MZRadioImageView!
    @IBOutlet weak var backGroundAlbumImageView: UIImageView!
    var needleImageView:UIImageView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let gesture = UISwipeGestureRecognizer(target: self, action: "toggleRightDrawer:")
        gesture.direction = .Left
        self.view.addGestureRecognizer(gesture)
        self.isRotating = true
        self.setupBackGroundImage()
        self.setupNeedleImage()
        let channel_id = NSUserDefaults.standardUserDefaults().integerForKey("currentChannelID")
        HttpTool.sharedInstance.getSong(channel_id) { (song) -> Void in
            AFSoundManager.sharedManager().startStreamingRemoteAudioFromURL(song.url, andBlock: { (percentage, elapsedTime, timeRemaining, error, finished) -> Void in
                if error == nil {
                    if finished {
                        
                    }else {
                        
                        
                        func generateString(time:CGFloat) -> String {
                            if !time.isNaN {
                                let all:Int = Int(time)
                                let m:Int = all%60
                                let f:Int = Int(all/60)
                                var time:String = ""
                                //小时
                                if f<10{
                                    time = "0\(f):"
                                }else{
                                    time = "\(f):"
                                }
                                // 分钟
                                if m<10{
                                    time += "0\(m)"
                                }else{
                                    time += "\(m)"
                                }
                                return time
                            } else {
                                return "00:00"
                            }
                        }
                    }
                }
            })
        }
        

        
        HttpTool.sharedInstance.getSong(0) { (song) -> Void in
            print(song.title)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.albumImageView.setupFrame(self.albumImageView.frame.width, img: nil)
        self.albumImageView.startRotation()
//        print("width:\(self.albumImageView.frame.width),x:\(self.albumImageView.frame.origin.x),y:\(self.albumImageView.frame.origin.y)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    


    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */


}


//MARK: - ActionFuncations
extension CenterViewController {
    @IBAction func playOrPause(sender: AnyObject) {
        if self.isRotating {
            self.albumImageView.pauseRotate()
            self.isRotating = false
            
            
            
            //按钮的图片设置
            self.buttonPlayorPause.setImage(UIImage(named: "cm2_btn_play"), forState: UIControlState.Normal)
            self.buttonPlayorPause.setImage(UIImage(named: "cm2_btn_play_prs"), forState: UIControlState.Highlighted)
        } else {
            self.albumImageView.resumeRotate()
            self.isRotating = true
            
            
            //按钮的图片设置
            self.buttonPlayorPause.setImage(UIImage(named: "cm2_btn_pause"), forState: UIControlState.Normal)
            self.buttonPlayorPause.setImage(UIImage(named: "cm2_btn_pause_prs"), forState: UIControlState.Highlighted)
            
        }
        
        UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
            if !self.isRotating {
                self.needleImageView.transform = CGAffineTransformMakeRotation(-CGFloat(M_PI / 6.0))
                
            }else {
                self.needleImageView.transform = self.needleOriginTransform
            }
            
            }, completion: { (finish) -> Void in
                
        })
        
    }
    
    func toggleRightDrawer(sender: UISwipeGestureRecognizer) {
        if(sender.direction == .Left){
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.toggleRightDrawer(sender, animated: true)
        }
    }
    
}

//MARK: - ViewSetupFuncations
extension CenterViewController {
    func setupBackGroundImage(){
        self.backGroundAlbumImageView.image = UIImage(named: "Love_and_Peace")
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        let veView = UIVisualEffectView(effect: blurEffect)
        veView.alpha = 1
        veView.frame = self.screenSize
        self.backGroundAlbumImageView.addSubview(veView)
    }
    
    func setupNeedleImage(){
        self.needleImageView = UIImageView(frame: CGRect(x: 165, y: 40, width: 96, height: 153))
        self.needleImageView.image = UIImage(named: "cm2_play_needle_play")
        self.setAnchorPonit(CGPoint(x: 0.25, y: 0.16), forView: self.needleImageView)
        self.needleOriginTransform = self.needleImageView.transform
        
        //        self.needleImageView.layer.anchorPoint = CGPoint(x: 0.25, y: 0.16)
        self.view.addSubview(needleImageView)
    }
    
    func setAnchorPonit(anchorPoint: CGPoint, forView view: UIView){
        var newPoint = CGPoint(x: view.bounds.size.width * anchorPoint.x, y: view.bounds.size.height * anchorPoint.y)
        var oldPoint = CGPoint(x: view.bounds.size.width * view.layer.anchorPoint.x, y: view.bounds.size.height * view.layer.anchorPoint.y)
        
        newPoint = CGPointApplyAffineTransform(newPoint, view.transform)
        oldPoint = CGPointApplyAffineTransform(oldPoint, view.transform)
        
        var position = view.layer.position
        position.x -= oldPoint.x
        position.x += newPoint.x
        
        position.y -= oldPoint.y
        position.y += newPoint.y
        
        view.layer.position = position
        view.layer.anchorPoint = anchorPoint
    }
}

//MARK: Implement protocols
extension CenterViewController {
    
    func selectChannel(channel_id: Int){
        HttpTool.sharedInstance.getSong(channel_id) { (song) -> Void in
            print("Changed Channel")
        }
    }
}
