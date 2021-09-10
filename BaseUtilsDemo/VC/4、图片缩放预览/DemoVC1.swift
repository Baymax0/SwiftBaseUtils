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
    
    @IBOutlet weak var imgBtn1: UIButton!
    @IBOutlet weak var imgBtn2: UIButton!
    @IBOutlet weak var imgBtn3: UIButton!

    let strArr = ["https://scpic2.chinaz.net/Files/pic/pic9/202109/bpic24150_s.jpg",
               "https://scpic3.chinaz.net/Files/pic/pic9/202109/bpic24151_s.jpg",
               "https://scpic.chinaz.net/Files/pic/pic9/202109/bpic24147_s.jpg"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imgBtn1.tag = 0
        imgBtn2.tag = 1
        imgBtn3.tag = 2
        
        imgBtn1.kf.setImage(with: strArr[imgBtn1.tag].resource, for: .normal)
        imgBtn2.kf.setImage(with: strArr[imgBtn2.tag].resource, for: .normal)
        imgBtn3.kf.setImage(with: strArr[imgBtn3.tag].resource, for: .normal)
    }

    // 点击预览图片
    @IBAction func clickAction(_ sender: Any) {
        self.previewImage(imgView.image!)
    }
    
    // 点击预览图片
    @IBAction func mutiImgClickAction(_ sender: UIButton) {
        
        self.reviewMutiNetimgs(imgs: strArr, index: sender.tag)
    }
}
