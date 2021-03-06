//
//  Kingfisher+Utils.swift
//  BaseUtils
//
//  Created by yimi on 2019/5/24.
//  Copyright © 2019 yimi. All rights reserved.
//




extension Optional where Wrapped == String{
    var resource:ImageResource?{
        if self == nil{
            return nil
        }else{
            return self!.resource
        }
    }
}

extension String{
    var resource:ImageResource! {
        if self.count == 0{
            return nil
        }
        guard self.contains("http") else {
            return nil
        }
        return ImageResource(downloadURL: URL(string: self)!)
    }
}

extension UIImageView {
    func setUrlImage(_ url:String) {
        self.kf.setImage(with: url.resource)
    }
}

