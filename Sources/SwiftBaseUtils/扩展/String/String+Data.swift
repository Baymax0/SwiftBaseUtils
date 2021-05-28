//
//  String+Data.swift
//  ys715
//
//  Created by 宇树科技 on 2021/5/19.
//

import Foundation

extension Data {
    func toString() -> String?{
        return String.init(data: self, encoding: String.Encoding.utf8)
    }
    
    func toBytes() -> [UInt8]? {
        if self.count == 0{
            return nil
        }
        let bytes = [UInt8](self)
        return bytes
    }
}

extension String {
    func toData() -> Data{
        self.data(using: String.Encoding.utf8)!
    }
}
