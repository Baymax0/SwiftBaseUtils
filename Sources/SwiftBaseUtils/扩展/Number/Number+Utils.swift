//
//  Number+Utils.swift
//  ys715
//
//  Created by 宇树科技 on 2021/4/26.
//

import Foundation

extension CGFloat{
    func between(_ minValue:CGFloat,_ maxValue:CGFloat) -> CGFloat {
        if self < minValue{
            return minValue
        } else if self > maxValue{
            return maxValue
        }
        return self
    }
}
extension Int{
    func between(_ minValue:Int,_ maxValue:Int) -> Int {
        if self < minValue{
            return minValue
        } else if self > maxValue{
            return maxValue
        }
        return self
    }
}

// 定义命名空间 方便找addConstraints 方法
//public final class Baymax<Base> {
//    public let base: Base
//    public init(_ base: Base) {
//        self.base = base
//    }
//}

//extension Baymax where Base: UIView
//
//
//
//public protocol BMBetweenProtocol :Comparable {
//    func getValueBetween(_ minValue:CGFloat,maxValue:CGFloat) -> CGFloat
//}
//
//extension BMBetweenProtocol {
//    func getValueBetween(_ minValue:CGFloat,maxValue:CGFloat) -> CGFloat {
//        if self < minValue{
//            return minValue
//        } else if self > maxValue{
//            return maxValue
//        }
//        return self
//    }
//}
//
//extension Int   :BMBetweenProtocol{}
//extension Float :BMBetweenProtocol{}
//extension Double:BMBetweenProtocol{}
//extension String:BMBetweenProtocol{}




