//
//  BtnClickAnimVC.swift
//  BaseUtilsDemo
//
//  Created by 李志伟 on 2020/12/25.
//  Copyright © 2020 yimi. All rights reserved.
//

import UIKit

class BtnClickAnimVC: BaseVC {
    
    var btn1: DOFavoriteButton!
    
    @IBOutlet weak var btn2: DOFavoriteButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.createWithCode()
    }
    
    func createWithCode() {
        btn1 = DOFavoriteButton(frame: .init(x: 0, y: 0, width: 70, height: 70), image: .name("upvote"))
        self.view.addSubview(btn1)
        btn1.imageColorOff = .brown
        btn1.imageColorOn = .red
        btn1.circleColor = .green
        btn1.lineColor = .blue
        btn1.duration = 4.0 // default: 1.0
        btn1.bm.addConstraints([.center_X(0), .top(50), .w(70), .h(70)])
        btn1.addTarget(self, action: #selector(clickAction(_:)), for: .touchUpInside)
    }

    
    @IBAction func clickAction(_ sender: DOFavoriteButton) {
        if sender.isSelected {
            sender.deselect()
        } else {
            sender.select()//触发点击动画
        }
    }
    
    
}
