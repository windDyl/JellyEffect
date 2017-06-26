//
//  ViewController.swift
//  JellyEffect
//
//  Created by dyLiu on 2017/6/22.
//  Copyright © 2017年 dyLiu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let jellEffectView:JellyEffectView = JellyEffectView(frame: self.view.bounds)
        jellEffectView.backgroundColor = UIColor.orange
        self.view.addSubview(jellEffectView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

