//
//  ViewController.swift
//  MZRadio
//
//  Created by Samuel37 on 15/9/30.
//  Copyright © 2015年 Samuel37. All rights reserved.
//

import UIKit
import KVNProgress

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        KVNProgress.setConfiguration(KVNProgressConfiguration.defaultConfiguration())
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewDidAppear(animated: Bool) {
        
        KVNProgress.showWithStatus("this is the test")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

