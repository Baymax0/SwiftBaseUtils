//
//  Number+BigNumber.swift
//  ys715
//
//  Created by 宇树科技 on 2021/8/16.
//

import Foundation

infix operator ++

extension String {
    
    static func ++(left:String,right:String) -> String{
        var resule = ""
        var leftArr:[String] = []
        for i in left.enumerated().reversed(){
            leftArr.append(String(i.element))
        }
        
        var rightArr:[String] = []
        for i in right.enumerated().reversed(){
            rightArr.append(String(i.element))
        }
        
        let maxNum = left.count > right.count ? left.count : right.count
        for i in 0..<maxNum{
            let l = leftArr.bm_object(i) ?? "0"
            let r = rightArr.bm_object(i) ?? "0"
            let s = l.toInt() + r.toInt()
            resule = s.toString()! + resule
        }
        return resule
    }
    
}
