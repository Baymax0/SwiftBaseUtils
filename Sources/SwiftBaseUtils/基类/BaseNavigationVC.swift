//
//  BaseNavigationVC.swift
//  BaseUtilsDemo
//
//  Created by yimi on 2019/10/11.
//  Copyright © 2019 yimi. All rights reserved.
//



class BaseNavigationVC: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.interactivePopGestureRecognizer?.delegate = self
//        self.view.backgroundColor = .white
    }
    
    // 拦截 push 操作
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if viewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
            if let vc = viewController as? BaseVC {
                viewController.navigationItem.leftBarButtonItem = self.barItem(vc, title: "", imgName: "BMback_Icon", action: #selector(vc.back))                
            }
        }
        super.pushViewController(viewController, animated: animated)
    }
}

extension BaseNavigationVC:UIGestureRecognizerDelegate{
    //侧滑返回
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if self.viewControllers.count<2{
            return false
        }
        return true
    }
}

