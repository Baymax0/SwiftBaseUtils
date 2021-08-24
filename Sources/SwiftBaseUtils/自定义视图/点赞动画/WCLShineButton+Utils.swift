//
//  WCLShineButton+Utils.swift
//  ys715
//
//  Created by 宇树科技 on 2021/8/6.
//

import UIKit

extension WCLShineButton {
    // 常用初始化
    func customInit(_ imgName:String){
        var param = WCLShineParams()
        param.allowRandomColor = true
        param.animDuration = 1
        
        self.isSelected = false
        self.params = param
        self.image = .custom(UIImage(named: imgName)!)
        
        self.color = .darkGray
        self.fillColor = .KOrange
    }
    
    // 选中
    func setChoosed(_ clicked: Bool){
        setClicked(clicked, animated: true)
    }
}
