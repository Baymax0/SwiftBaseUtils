//
//  Const.swift
//  wangfuAgent
//
//  Created by lzw on 2018/7/11.
//  Copyright © 2018 zhuanbangTec. All rights reserved.
//



let YES = true
let NO = false

let KPageSize:Int = 10
let KReloadIntervalTime:Double = 600
func getAvatar(_ seed:Int)-> String{
    let arr = [
        "https://pic3.zhimg.com/v2-54c96a414d0490cfe489562c611e04ae_xll.jpg",
        "https://pic3.zhimg.com/v2-cbc8a95781cc1fce6a9d6ff52affc3e9_xll.jpg",
        "https://pic1.zhimg.com/v2-d3fb6692ad12779e2884024725102d3c_xll.jpg",
        "https://pic4.zhimg.com/v2-0318dcb8e526fb2ba9fe63f9e03b3c7c_xll.jpg",
        "https://pic1.zhimg.com/v2-955df8c8ecb0ba92da01f65eab447b9f_xl.jpg",
        "https://pic3.zhimg.com/v2-5fb535a8b6951c6e2fad1b27ab70b7cd_xl.jpg",
        "https://pic3.zhimg.com/v2-68f4027d488f051f886146f70dadee68_xl.jpg",
        "https://pic3.zhimg.com/v2-aa59ce25eca7c573f3e8a90826b2065b_xl.jpg",
        "https://pic3.zhimg.com/v2-e195d5e40783ee87d8e854bfa2b4fd09_xl.jpg",
        "https://pic3.zhimg.com/v2-75ee376ea51ec1685e3d6ca284e4dec6_xl.jpg",
        "https://pic1.zhimg.com/v2-40722cb01280161ffc189556b6bd41c6_xl.jpg",
        "https://pic1.zhimg.com/v2-0380c5940257f76a8983917fd4a40490_xl.jpg",
        "https://pic3.zhimg.com/v2-c4003221664b9fb130f4f76caf184123_xl.jpg",
    ]
    var index = Int(Date().toTimeInterval())
    index = (index + seed * 3) % arr.count
    return arr[index]
}

func getUserName(_ seed:Int)-> String{
    let arr = [
        "林之辛",
        "焰瞳雪兔君",
        "TIANYU",
        "一只蚂蚁",
        "普通人",
        "横眉",
        "星辰大海",
        "洛克马戏初号机",
        "龙牙的一座山",
        "秋山覺",
        "Chris Chou",
        "在海的那边",
        "卷心菜",
    ]
    var index = Int(Date().toTimeInterval())
    index = (index + seed * 3) % arr.count
    return arr[index]
}


func bm_print(_ items: Any..., separator: String = " ", terminator: String = "\n"){
    #if DEBUG
    print(items, separator: separator, terminator: terminator)
    #endif
}

func judgeScream() -> Bool {
    return safeArea(.top) != 0
}

public enum SafeDirect{
    case top
    case left
    case bottom
    case right
}

func safeArea(_ direct:SafeDirect) -> CGFloat{
    if #available(iOS 11.0, *) {
        if let inset = UIApplication.shared.windows.filter({$0.isKeyWindow}).first?.safeAreaInsets{
            if direct == .top{ return inset.top }
            if direct == .left{ return inset.left }
            if direct == .bottom{ return inset.bottom }
            if direct == .right{ return inset.right }
        }
        return 0
    }
    return 0
}

/// safeArea
let safeArea_Top    = safeArea(.top)
/// safeArea
let safeArea_Bottom = safeArea(.bottom)

/// 屏幕的宽度
let KScreenWidth    = UIScreen.main.bounds.width
/// 屏幕的高度
let KScreenHeight   = UIScreen.main.bounds.height
/// 是否是IphoneX
let KIsIphoneX      = judgeScream()
/// 导航栏下内容高度
let KHeightInNav    = KScreenHeight - KNaviBarH
/// 导航栏高度
let KNaviBarH       = safeArea(.top) + 44
/// tabbar高度
let KTabBarH        = safeArea(.bottom) + 49

/// 375下的尺寸  size*KRatio375
let KRatio375       = UIScreen.main.bounds.width / 375.0


let noti = NotificationCenter.default


#if DEBUG
var DEBUG = true
#else
var DEBUG = false
#endif

extension NSNotification.Name {
    static let needRelogin = NSNotification.Name("needRelogin")
}



