//
//  UIView+RemoveSubviews.swift
//  ys715
//
//  Created by 宇树科技 on 2021/9/25.
//

import Foundation

extension UIView {
    func removeAllSubviews(){
        for v in self.subviews{
            v.removeFromSuperview()
        }
    }
}
