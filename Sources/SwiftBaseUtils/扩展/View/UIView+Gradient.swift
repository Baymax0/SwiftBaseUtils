//
//  UIView+Gradient.swift
//  ys715
//
//  Created by 宇树科技 on 2021/5/26.
//

import Foundation

extension UIView {

    func addGradient(_ color:[UIColor], start:CGPoint, end:CGPoint){
        let gradientLayer = CAGradientLayer()
        let cgColors = color.compactMap { return $0.cgColor }
        gradientLayer.colors = cgColors
        gradientLayer.locations = [0.2,1.0]//颜色的分界点
        //开始
        gradientLayer.startPoint = start
        //结束,主要是控制渐变方向
        gradientLayer.endPoint  = end
        
        gradientLayer.frame = self.bounds
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
}
