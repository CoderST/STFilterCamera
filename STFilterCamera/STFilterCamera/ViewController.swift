//
//  ViewController.swift
//  STFilterCamera
//
//  Created by xiudou on 2016/12/21.
//  Copyright © 2016年 CoderST. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let cameraView = STCameraView(frame: view.bounds)
        
        view.addSubview(cameraView)

    }



}

