//
//  MaskViewUsedVC.swift
//  BaseUtilsDemo
//
//  Created by 李志伟 on 2020/12/23.
//  Copyright © 2020 yimi. All rights reserved.
//

import UIKit

class MaskViewUsedVC: BaseVC {

    @IBOutlet var chooseView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func alertViewAction(_ sender: UIButton) {
        if sender.tag == 0 {
            // 在中间弹出选择框
            self.showMaskWithViewInCenter(chooseView)
        }
        if sender.tag == 1 {
            // 在底下弹出选择框
            self.showMaskWithViewAtBottom(chooseView)
        }
    }
    
    // 选择框按钮事件
    @IBAction func changeColorAction(_ sender: UIButton) {
        if sender.tag == 0 {
            self.view.backgroundColor = .hex("C25451")
        }else if sender.tag == 1 {
            self.view.backgroundColor = .hex("4580C8")
        }else if sender.tag == 2 {
            self.view.backgroundColor = .hex("FAADD6")
        }
        // 隐藏maskview，包括隐藏maskview上的view
        self.hideMaskView()
    }
    
}


