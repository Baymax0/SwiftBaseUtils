//
//  UIView+IBInspectable.swift
//  wangfuAgent
//
//  Created by lzw on 2018/8/8.
//  Copyright © 2018 zhuanbangTec. All rights reserved.
//

import UIKit


extension UIView{
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var addShadow: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.shadowColor = #colorLiteral(red: 0.703776896, green: 0.7038969398, blue: 0.7037611604, alpha: 1).cgColor
            layer.masksToBounds = false
            layer.shadowOpacity = 0.3
            layer.shadowRadius = 4
            layer.shadowOffset = CGSize(width: 2, height: 2)
        }
    }
    
    @IBInspectable var shadow_CornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable var shadow_Color: UIColor {
        get {
            if layer.shadowColor == nil {
                return .clear
            }else{
                return UIColor.init(cgColor: layer.shadowColor!)
            }
        }
        set {
            layer.shadowColor = newValue.cgColor
            layer.shadowOpacity = 0.8
            layer.shadowOffset = CGSize(width: 1, height: 1)
        }
    }
    
    @IBInspectable var shadow_Width: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    func showWithAnimation(_ time:Double = 0.2){
        self.alpha = 0
        UIView.animate(withDuration: time) {
            self.alpha = 1
        }
    }
    
    func showWithAnimation(delay:Double, _ time:Double = 0.2){
        self.alpha = 0
        UIView.animate(withDuration: time, delay: delay,animations: {
            self.alpha = 1
        }) { (_) in
            
        }
    }
    
    var x:CGFloat{
        get{
            return self.frame.origin.x
        }
        set{
            self.frame.origin.x = newValue
        }
    }
    var y:CGFloat{
        get{
            return self.frame.origin.y
        }
        set{
            self.frame.origin.y = newValue
        }
    }
    var w:CGFloat{
        get{
            return self.frame.width
        }
        set{
            self.frame.size.width = newValue
        }
    }
    var h:CGFloat{
        get{
            return self.frame.height
        }
        set{
            self.frame.size.height = newValue
        }
    }
    
    var centerX:CGFloat{
        get{
            return self.center.x
        }
        set{
            self.center.x = newValue
        }
    }
    var centerY:CGFloat{
        get{
            return self.center.y
        }
        set{
            self.center.y = newValue
        }
    }
    var maxY:CGFloat{
        return self.frame.maxY
    }
    var maxX:CGFloat{
        return self.frame.maxX
    }
    ///生成图片
    func toImage() -> UIImage?{
        
        UIGraphicsBeginImageContextWithOptions(self.frame.size, false, UIScreen.main.scale)
        self.layer.render(in: UIGraphicsGetCurrentContext()!)
        let img: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return img
    }
    ///删除一个view 下的所有子view
    func clearAll(){
        if self.subviews.count > 0 {
            self.subviews.forEach({ $0.removeFromSuperview()})
        }
    }
}

