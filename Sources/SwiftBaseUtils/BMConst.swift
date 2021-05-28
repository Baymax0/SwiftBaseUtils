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

extension NSNotification.Name {
    static let needRelogin = NSNotification.Name("needRelogin")
}



