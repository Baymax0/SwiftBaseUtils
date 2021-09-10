//
//  BaseVC+Navi.swift
//  ys715
//
//  Created by 宇树科技 on 2021/9/2.
//

import Foundation

// MARK:  页面导航
extension BaseVC {
    // 预览多图
    func reviewMutiNetImgs(imgs:[String],index:Int){
        let view = BMPreviewView.createWith(imgs,index: index)
        view.show()
    }
}

