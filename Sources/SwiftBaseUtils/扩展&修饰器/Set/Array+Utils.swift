//
//  Sting+Utils.swift
//  wangfuAgent
//
//  Created by lzw on 2018/7/18.
//  Copyright © 2018 zhuanbangTec. All rights reserved.
//


extension Array{
    
    // 防止越界崩溃
    func bm_object(_ at:Int) -> Element? {
        if at >= self.count || at < 0{
            return nil
        }else{
            return self[at]
        }
    }
    
    func getJsonStr() -> String?{
        let data = try? JSONSerialization.data(withJSONObject: self, options: [])
        if data != nil{
            let strJson = String(data: data!, encoding: String.Encoding.utf8)
            return strJson
        }
        return nil
    }
    
    // 遍历
    public func traversal(_ transform: (Element,Int) -> ()){
        for index in 0..<self.count{
            let item = self[index]
            transform(item,index)
        }
    }
    
    func reverseEnumerated() -> [(Int,Element)]{
        var result:[(Int,Element)] = []
        let count = self.count
        for (index,e) in self.enumerated().reversed(){
            let v = (index, e)
            result.append(v)
        }
        return result
    }

}

extension Optional {
    var notEmpty: Bool {
        guard self != nil else { return false }
        if let str = self as? String{
            if str.count == 0 {
                return false
            }
        }
        
        if let arr = self as? Array<Any>{
            if arr.count == 0 {
                return false
            }
        }
        return true
    }
}

