//
//  BMAlertView.swift
//  ys715
//
//  Created by 宇树科技 on 2021/8/19.
//

import Foundation

struct BMAlertView {
    
    /// 单按钮 & 无回调的提示框
    static func showAlert(title: String?, message: String?, actionTitle:String = "确定"){
        AlertController.alert(withTitle: title, message: message, actionTitle: actionTitle)
    }
    
    /// 确认 & 取消 & 确认回调的提示框
    static func showConfirm(title: String?, message: String?, okTitle:String = "确定", cancelTitle:String = "取消",handle: @escaping (() -> ())){
        let alert = AlertController(title: title, message: message)
        alert.addAction(AlertAction(title: cancelTitle, style: .preferred))
        alert.addAction(AlertAction(title: okTitle, style: .normal, handler: { (action) in
            handle()
        }))
        alert.present()
    }
    
    /// 自定义ActionSheet
    static func showActionSheet(title:String?, optionsTitles:[String], handle: @escaping ((Int) -> ())){
        let alert = AlertController(title: title, message: nil, preferredStyle: .actionSheet)
        var index = 0
        for optionsTitle in optionsTitles{
            let action = AlertAction(title: optionsTitle, style: .normal) { (action) in
                handle(action.tag!)
            }
            action.tag = index
            index += 1
            alert.addAction(action)
        }
        alert.addAction(AlertAction(title: "取消", style: .preferred))
        alert.present()
    }
    
    static func showShareView(_ v:UIView, contentH:CGFloat){
        let alert = AlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let contentView = alert.contentView
        contentView.addSubview(v)
        v.bm.addConstraints([.fill, .h(contentH)])
        alert.addAction(AlertAction(title: "取消", style: .preferred))
        alert.present()
    }
    
    static func showInputAlert(title: String?, message: String?, handle: @escaping ((String?) -> ())){
        let alert = AlertController(title: title, message: message)
        alert.addTextField()
        alert.addAction(AlertAction(title: "取消", style: .preferred))
        alert.addAction(AlertAction(title: "确定", style: .normal, handler: { (action) in
            let str = alert.textFields?.last?.text
            handle(str)
        }))
        
        alert.present()
            
    }
    
    
    static func showCenterCustomView(_ v:UIView, w:CGFloat, h:CGFloat) -> BMCustomAlertViewController{
        let alert = BMCustomAlertViewController(v, w: w, h: h)
        alert.present()
        return alert
    }
}

