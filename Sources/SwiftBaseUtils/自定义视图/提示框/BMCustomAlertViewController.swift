//
//  BMCustomAlertView.swift
//  ys715
//
//  Created by 宇树科技 on 2021/9/2.
//

import Foundation
import UIKit

public final class BMCustomAlertViewController: UIViewController {

    var dismissView:UIView!
    
    var contentView:UIView!
    var contentViewBottom:NSLayoutConstraint!
    
    public init(_ customView:UIView,w:CGFloat,h:CGFloat){
        super.init(nibName: nil, bundle: nil)
        self.initUI()
        self.contentView.addSubview(customView)
        customView.bm.addConstraints([.center, .w(w), .h(h)])
    }
    
    //MARK: ------------ UI ------------

    func initUI(){
        dismissView = UIView()
        dismissView.bm.addConstraints(superView: self.view, constraints:[.fill])
        dismissView.backgroundColor =  UIColor(white: 0, alpha: 0.2)
        let tap = UITapGestureRecognizer(target: self, action: #selector(backAction))
        self.view.addGestureRecognizer(tap)
        
        contentView = UIView()
        contentViewBottom = dismissView.bm.addConstraints(superView: self.view, constraints:[.fill]).bm_object(2)//拿到距下距离
        
        NotificationCenter.default
            .addObserver(self, selector: #selector(self.keyboardChange),
                         name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    public override func viewWillAppear(_ animated: Bool) {
        self.dismissView.alpha = 0
        UIView.animate(withDuration: 0.2) {
            self.dismissView.alpha = 1
        }
    }
    
    @objc func keyboardChange(_ notification: Notification) {
        let newFrameValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        guard let newFrame = newFrameValue?.cgRectValue else {
            return
        }
        UIView.animate(withDuration: 0.2) {
            self.contentViewBottom.constant = newFrame.maxY
            self.view.layoutIfNeeded()
        }
    }
    
    //MARK: ------------ Action ------------
    @objc func backAction(){
        guard presentedViewController == nil else {
            super.dismiss(animated: true, completion: nil)
            return
        }
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    public func present(animated: Bool = true, completion: (() -> Void)? = nil) {
        let topViewController = UIViewController.topViewController()
        self.modalPresentationStyle = .fullScreen
        topViewController?.present(self, animated: false, completion: completion)
    }
    
    //MARK: ------------ Noti ------------

    
}


