//
//  Number+Formate.swift
//  BaseUtilsDemo
//
//  Created by 李志伟 on 2020/12/11.
//  Copyright © 2020 yimi. All rights reserved.
//



enum NumberFormateType:String{
    // 精确位数
    case float_0    // 整数
    case float_1    // 小数点后1位
    case float_2    // 小数点后2位
    case float_3    // 小数点后3位

    // 格式化
    case comma // 大数字 用逗号： 77,335,444
    case hideDot      // 当小数点后为0 省略

    // 单位
    case fileSize   // 带单位后缀 22MB 4.123GB
    // 时间
    case minute   // 分钟 结果除以60
    case hour     // 分钟 结果除以60*60
    case day      // 分钟 结果除以60*60*24
}

protocol BMNumberFormate {
    func getFormateString(_ formates:[NumberFormateType]) -> String
}


extension String : BMNumberFormate{
    func getFormateString(_ formates: [NumberFormateType]) -> String {
        guard let fl = Double(self) else { return "0"}
        return fl.getFormateString(formates)
    }
}

extension Double : BMNumberFormate{
    func getFormateString(_ formates:[NumberFormateType]) -> String{
        var fl = self
        var result = "" //结果
        var suffix = ""   //后缀
        
        for t in formates{
            if t == .minute{
                fl = fl / 60
            }
            if t == .hour{
                fl = fl / 3600
            }
            if t == .day{
                fl = fl / (3600 * 24)
            }
        }
        
        for t in formates{
            if t == .fileSize{
                var temp:Double = fl
                suffix = "B"
                if temp >= 1024{
                    temp = temp/1024
                    suffix = "KB"
                }
                if temp >= 1024{
                    temp = temp/1024
                    suffix = "MB"
                }
                if temp >= 1024{
                    temp = temp/1024
                    suffix = "GB"
                }
                fl = temp
            }
        }
        
        for t in formates{
            if t == .float_0{
                result = String(format: "%d", Int(fl))
            }
            if t == .float_1{
                result = String(format: "%0.1f", fl)
            }
            if t == .float_2{
                result = String(format: "%0.2f", fl)
            }
            if t == .float_3{
                result = String(format: "%0.3f", fl)
            }
        }
        if result.count == 0{
            //默认是两个精度，其他自己传
            result = String(format: "%0.2f", fl)
        }
        for t in formates{
            if t == .hideDot{
                if result.contains(".") {
                    let arr = result.components(separatedBy: ".")
                    var s1 = arr.bm_object(1) ?? ""
                    let s0 = arr.bm_object(0) ?? ""
                    while s1.count > 0 && s1.hasSuffix("0"){
                        s1 = s1[..<(-1)]
                    }
                    s1 = s1.count == 0 ? "":("." + s1)
                    result = s0 + s1
                }
            }
            if t == .comma{
                // 根据整数位的长度 加 ","
                // 如果包含小数点先剔除小数点
                var temp = result
                var others = ""
                if result.contains(".") {
                    let arr = result.components(separatedBy: ".")
                    temp = arr.bm_object(0) ?? ""
                    others = arr.bm_object(1) ?? ""
                    others = "." + others
                }
                
                let length = temp.count
                var index = 3
                while length > index {
                    assert(index < temp.count, "index 越界")
                    if index < temp.count{
                        temp.insert(",", at: temp.index(temp.startIndex, offsetBy: (temp.count-index)))
                        index = index + 4
                    }
                }
                result = temp + others
            }
        }
        result = result + suffix
        return result
    }
}
