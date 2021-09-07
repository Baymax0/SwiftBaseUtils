//
//  BaseVC+CustomAlert.swift
//  ys715
//
//  Created by 宇树科技 on 2021/9/2.
//

import Foundation

// MARK:  提示框
extension BaseVC {
    
    func listenForKeyboardChanges(){
        NotificationCenter.default
            .addObserver(self, selector: #selector(self.keyboardChange),
                         name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc func keyboardChange(_ notification: Notification) {
        let newFrameValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        guard let newFrame = newFrameValue?.cgRectValue else {
            return
        }

        if alertContentBtnBottom != nil{
            UIView.animate(withDuration: 0.2, animations: {
                self.alertContentBtnBottom.constant = -(KScreenHeight - newFrame.minY)
                self.alertContentBtn.superview!.layoutIfNeeded()
            })
        }
    }
    
    private func showMask(){
        if maskView == nil{ // 初始化 maskView
            maskView = UIView()
            maskView.backgroundColor = UIColor.maskView
        }
        if alertContentBtn == nil{// 初始化 alertContentBtn
            alertContentBtn = UIButton(frame: .init(x: 0, y: 0, width: KScreenWidth, height: KScreenHeight))
            alertContentBtn.backgroundColor = .clear
            alertContentBtn.addTarget(self, action: #selector(hideMaskView), for: .touchUpInside)
        }
        
        if maskView.superview == nil{
            self.window.addSubview(maskView)
            maskView.bm.addConstraints([.fill])
        }
        if alertContentBtn.superview == nil{
            alertContentBtn.removeFromSuperview()
            self.window.addSubview(alertContentBtn)
            self.alertContentBtnBottom = alertContentBtn.bm.addConstraints([.fill]).bm_object(2)
            self.window.layoutIfNeeded()
        }
        
        maskView.alpha = 0
        UIView.animate(withDuration: 0.2, animations: {
            self.maskView.alpha = 1
        })
    }
    
    /// 居中显示View
    func showMaskWithViewInCenter(_ content:UIView, listenTorKeyboard:Bool = false){
        showMask()
        alertContentBtn.tag = 0
        if listenTorKeyboard{
            self.listenForKeyboardChanges()
        }
        content.bm.addConstraints(superView: alertContentBtn, constraints: [.w(content.w), .h(content.h), .center])
        content.layoutIfNeeded()
        alertContentBtn.layoutIfNeeded()
        //animation
        content.alpha = 0.5 //透明度渐变不带弹性
        UIView.animate(withDuration: 0.2, animations: {
            content.alpha = 1
        })
        content.transform = CGAffineTransform.init(scaleX: 0.5, y: 0.5) //缩放带弹性
        UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 5, options: .curveEaseInOut, animations: {
            content.transform = CGAffineTransform.identity
        }) { (_) in}
    }
    
    
    
    /// 居下显示View
    func showMaskWithViewAtBottom(_ content:UIView){
        showMask()
        
        alertContentBtn.tag = 1;

        content.removeFromSuperview()
        alertContentBtn.addSubview(content)//把view的宽高布局转为约束
        content.bm.addConstraints([.w(content.w), .h(content.h), .center_X(0), .bottom(40)])
        
        //animation
        content.alpha = 0.5 //透明度渐变不带弹性
        UIView.animate(withDuration: 0.2, animations: {
            content.alpha = 1
        })
        
        content.transform = CGAffineTransform.init(translationX: 0, y: 100) //缩放带弹性
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 5, options: .curveEaseInOut, animations: {
            content.transform = CGAffineTransform.identity
        }) { (_) in}
    }
    
    /// 居下显示View
    func showMaskWithViewAtBottom_full(_ content:UIView){
        showMask()
        
        alertContentBtn.tag = 1;
        content.removeFromSuperview()
        alertContentBtn.addSubview(content)//把view的宽高布局转为约束
        content.bm.addConstraints([.w(content.w), .h(content.h), .center_X(0), .bottom(0)])
        
        self.alertBottomView = content as? CustomBottomAlertViewDelagate
        if let v = self.alertBottomView{
            v.willAppear()
        }
        
        //animation
//        content.alpha = 0.5 //透明度渐变不带弹性
        UIView.animate(withDuration: 0.2, animations: {
//            content.alpha = 1
        })
        
        content.alpha = 1

        content.transform = CGAffineTransform.init(translationX: 0, y: content.h)
        let time:Double = Double(content.h) / 2100
        UIView.animate(withDuration: time, delay: 0, options: .curveEaseOut) {
            content.transform = CGAffineTransform.identity
        } completion: { (_) in
            if let v = self.alertBottomView{
                v.didAppear()
            }
        }
    }
    
    /// 自定义位置显示View
    func showMaskWithView(_ content:UIView, from:CGRect,to:CGRect){
        showMask()
        
        alertContentBtn.tag = 1;
        alertContentBtn.addTarget(self, action: #selector(hideMaskView), for: .touchUpInside)

        content.removeFromSuperview()
        alertContentBtn.addSubview(content)//把view的宽高布局转为约束
        content.frame = from
        
        //animation
        content.alpha = 0.5 //透明度渐变不带弹性
        UIView.animate(withDuration: 0.2, animations: {
            content.alpha = 1
        })
        
//        content.transform = CGAffineTransform.init(translationX: 0, y: 50) //缩放带弹性
        UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 5, options: .curveEaseInOut, animations: {
            content.frame = to
        }) { (_) in}
    }
    
    /// 隐藏
    @objc func hideMaskView() -> Void {
        // 取消用于回调的引用
        if let v = self.alertBottomView{
            v.willDisappear()
            self.alertBottomView = nil
        }
        
        if alertContentBtn == nil{
            return
        }
        let content = alertContentBtn.subviews.last//提示框
        
        UIView.animate(withDuration: 0.3) {
            self.maskView.alpha = 0
        } completion: { (_) in
            self.maskView.removeFromSuperview()
        }

        UIView.animate(withDuration: 0.15, animations: {
            content?.alpha = 0
            if self.alertContentBtn.tag == 1{
                content?.transform = CGAffineTransform.init(translationX: 0, y: 80)
            }else{
                content?.transform = CGAffineTransform.init(scaleX: 0.5, y: 0.5)
            }
        }) { (_) in
            content?.removeFromSuperview()
            content?.transform = CGAffineTransform.identity
            self.alertContentBtn.removeFromSuperview()
        }
        NotificationCenter.default.removeObserver(self)
        
        self.closeKeyboard()
    }
}


