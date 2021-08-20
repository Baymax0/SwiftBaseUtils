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
    static func showConfirm(title: String?, message: String?, okTitle:String = "确定", cancelTitle:String = "确定",handle: @escaping (() -> ())){
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
    
    
}

//private func showAlertView(_ title:String, _ msg:String, complish: (() -> ())? = nil, cancel: (() -> ())? = nil){
//    UIView.animate(withDuration: 0.1) {
//        let alertVC = UIAlertController(title: title, message: msg, preferredStyle: .alert)
//        let okAction = UIAlertAction(title: "确认", style: .default, handler: { (action) in
//            complish?()
//        })
//        let cancelAction = UIAlertAction(title: "取消", style: .cancel , handler:{ (action) in
//            cancel?()
//        })
//        alertVC.addAction(cancelAction)
//        alertVC.addAction(okAction)
//        self.present(alertVC, animated: YES, completion: nil)
//    }
//}
//
//func showComfirm(_ title:String, _ msg:String, cancel:(()->())? = nil, complish:(()->())? = nil){
//    self.showAlertView(title, msg, complish: complish, cancel: cancel)
//
//}
