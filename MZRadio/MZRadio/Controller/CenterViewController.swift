//
//  CenterViewController.swift
//  MZRadio
//
//  Created by Samuel37 on 15/10/16.
//  Copyright © 2015年 Samuel37. All rights reserved.
//

import UIKit
import SDWebImage
import AFSoundManager
import KVNProgress


class CenterViewController: UIViewController, ChannelSelectProtocol {
    
    
    @IBOutlet weak var buttonPlayorPause: UIButton!
    let screenSize = UIScreen.mainScreen().bounds
    var isRotating: Bool = false
    var needleOriginTransform: CGAffineTransform!
    @IBOutlet weak var albumImageView: MZRadioImageView!
    @IBOutlet weak var backGroundAlbumImageView: UIImageView!
    var needleImageView:UIImageView!
    var afPlayer:AFSoundQueue!
    
    override func viewDidLoad() {
        UIApplication.sharedApplication().statusBarHidden = true
        super.viewDidLoad()
        
        let gesture = UISwipeGestureRecognizer(target: self, action: "toggleRightDrawer:")
        gesture.direction = .Left
        self.view.addGestureRecognizer(gesture)
        self.isRotating = true
        self.setupBackGroundImage(nil)
        self.setupNeedleImage()
        HttpTool.sharedInstance.getSong(0) { (song) -> Void in
            let item = AFSoundItem(streamingURL: NSURL(string: song.url))
            self.afPlayer = AFSoundQueue(items: [item])
            self.afPlayer.playCurrentItem()
            self.afPlayer.listenFeedbackUpdatesWithBlock({ (item) -> Void in
                 print(1)
                }, andFinishedBlock: { (item) -> Void in
                    print(2)
            })
            self.changeImages(UIImage(data: NSData(contentsOfURL: NSURL(string: song.picture)!)!)!)
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
            self.afPlayer.pause()
            
            
            //按钮的图片设置
            self.buttonPlayorPause.setImage(UIImage(named: "cm2_btn_play"), forState: UIControlState.Normal)
            self.buttonPlayorPause.setImage(UIImage(named: "cm2_btn_play_prs"), forState: UIControlState.Highlighted)
        } else {
            self.albumImageView.resumeRotate()
            self.isRotating = true
            
            self.afPlayer.playCurrentItem()
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
    func setupBackGroundImage(url: UIImage?){
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
    
    func changeImages(image: UIImage){
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            
            self.albumImageView.albumView.image = image
            self.backGroundAlbumImageView.image = image
        })

    }
}

//MARK: Implement protocols
extension CenterViewController {
    
    func selectChannel(channel_id: Int){
        HttpTool.sharedInstance.getSong(channel_id) { (song) -> Void in
//            KVNProgress.showWithStatus("Loading")
            print("Changed Channel")
            
            let item = AFSoundItem(streamingURL: NSURL(string: song.url))
            self.afPlayer.addItem(item)
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
                self.afPlayer.playNextItem()
            })
            self.changeImages(UIImage(data: NSData(contentsOfURL: NSURL(string: song.picture)!)!)!)
            
        }
    }
}
