//
//  DemoVC1.swift
//  BaseUtilsDemo
//
//  Created by yimi on 2019/10/10.
//  Copyright © 2019 yimi. All rights reserved.
//

import UIKit

class DemoVC1: BaseVC {

    @IBOutlet weak var imgView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // 点击预览图片
    @IBAction func clickAction(_ sender: Any) {
        self.previewImage(imgView.image!)
        return
    }
    
}
