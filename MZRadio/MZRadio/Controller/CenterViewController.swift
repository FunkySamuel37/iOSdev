//
//  CenterViewController.swift
//  MZRadio
//
//  Created by Samuel37 on 15/10/16.
//  Copyright © 2015年 Samuel37. All rights reserved.
//

import UIKit

class CenterViewController: UIViewController {
    
    
    @IBOutlet weak var buttonPlayorPause: UIButton!
    let screenSize = UIScreen.mainScreen().bounds
    var isRotating: Bool = false
    var needleOriginTransform: CGAffineTransform!
    @IBOutlet weak var albumImageView: MZRadioImageView!
    @IBOutlet weak var backGroundAlbumImageView: UIImageView!
    var needleImageView:UIImageView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        self.setupNeedleImage()
        let gesture = UISwipeGestureRecognizer(target: self, action: "toggleRightDrawer:")
        gesture.direction = .Left
        self.view.addGestureRecognizer(gesture)
        self.isRotating = true
        self.setupBackGroundImage()
        self.setupNeedleImage()
        HttpTool.sharedInstance.getChannel { (channels) -> Void in
//            print(channels[0].name)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.albumImageView.setupFrame(self.albumImageView.frame.width, img: nil)
        self.albumImageView.startRotation()


        
        print("width:\(self.albumImageView.frame.width),x:\(self.albumImageView.frame.origin.x),y:\(self.albumImageView.frame.origin.y)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func toggleRightDrawer(sender: UISwipeGestureRecognizer) {
        if(sender.direction == .Left){
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.toggleRightDrawer(sender, animated: true)
        }
    }

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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */


}
