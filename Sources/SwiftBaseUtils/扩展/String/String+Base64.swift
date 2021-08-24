//
//  String+Base64.swift
//  LoveStory
//
//  Created by 宇树科技 on 2021/4/16.
//

import Foundation

extension String{
    
    var base64Encoding:String{
        let data    = self.data(using: .utf8)!
        let encode  = data.base64EncodedString()
        return encode
    }
    
    var base64Decoding:String{
        let data    = Data(base64Encoded: self)!
        let decode  = String(data: data, encoding: .utf8)
        return decode ?? ""
    }
    
    
}
