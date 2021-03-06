//
//  Any+Utils.swift
//  wangfuAgent
//
//  Created by lzw on 2018/7/30.
//  Copyright © 2018 zhuanbangTec. All rights reserved.
//

extension Int{
    func toString() -> String?{
        return String(self)
    }
}

extension Double{
    func toString() -> String?{
        return String(self)
    }
}

extension Float{
    func toString() -> String?{
        return String(self)
    }
}



// MARK: -  ---------------------- 转换 ------------------------
extension String{
    ///判断 是否 是 数字
    var isPurnInt:Bool {
        let scan: Scanner = Scanner(string: self)
        var val:Int = 0
        return scan.scanInt(&val) && scan.isAtEnd
    }
    
    var isPurnDouble:Bool {
        let scan: Scanner = Scanner(string: self)
        var val:Double = 0
        return scan.scanDouble(&val) && scan.isAtEnd
    }
    
    func  toInt() -> Int{
        if let i = Int(self){
            return i
        }else{
            return 0
        }
    }
    
    func toFloat() -> Float{
        if let i = Float(self){
            return i
        }else{
            return 0
        }
    }
    
    func toDouble() -> Double{
        if let i = Double(self){
            return i
        }else{
            return 0
        }
    }
}

// MARK: -  ----------------------  ------------------------
extension Optional where Wrapped == String{
    /// if nil return 0
    var bm_count:Int{
        if self == nil{
            return 0
        }else{
            return self!.count
        }
    }
    
    func toInt() -> Int{
        if self == nil{
            return 0
        }else{
            if let i = Int(self!){
                return i
            }else{
                return 0
            }
        }
    }
    
    func toFloat() -> Float{
        if self == nil{
            return 0
        }else{
            if let i = Float(self!){
                return i
            }else{
                return 0
            }
        }
    }
    
    func toDouble() -> Double{
        if self == nil{
            return 0
        }else{
            if let i = Double(self!){
                return i
            }else{
                return 0
            }
        }
    }
}






