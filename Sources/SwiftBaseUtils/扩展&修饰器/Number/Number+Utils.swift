//
//  Number+Utils.swift
//  ys715
//
//  Created by 宇树科技 on 2021/4/26.
//

import Foundation

//MARK: ------------ CGFloat ------------

extension Comparable {
    func between (_ minValue: Self, _ maxValue: Self) -> Self{
        var minV = minValue
        var maxV = maxValue
        if minValue > maxValue{
            minV = maxValue
            maxV = minValue
        }
        if self < minV{
            return minV
        } else if self > maxV{
            return maxV
        }
        return self
    }
}


extension Int{
    // 向下取整  4.1 返回 4
    func divideWithFloor(_ d:Int) -> Int{
        let divideValue = self / d
        return divideValue
    }
    
    // 向上取整 4.1 返回 5
    func divideWithCeiling(_ d:Int) -> Int{
        var divideValue = self / d
        if divideValue * d < self{
            divideValue = divideValue + 1
        }
        return divideValue
    }
    
}



