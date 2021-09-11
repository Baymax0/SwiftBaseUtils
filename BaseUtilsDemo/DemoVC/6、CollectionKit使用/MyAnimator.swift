//
//  MyAnimator.swift
//  BaseUtilsDemo
//
//  Created by 李志伟 on 2020/12/28.
//  Copyright © 2020 yimi. All rights reserved.
//

import UIKit

open class MyAnimator: SimpleAnimator{
    open var alpha: CGFloat = 0
    
    open override func hide(view: UIView) {
        view.alpha = alpha
        view.transform = CGAffineTransform.identity.scaledBy(x: 1.4, y: 1.4)
    }
    
    open override func show(view: UIView) {
        view.alpha = 1
        view.transform = CGAffineTransform.identity
    }
    
}

