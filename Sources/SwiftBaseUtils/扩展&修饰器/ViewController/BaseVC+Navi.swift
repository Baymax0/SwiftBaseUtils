//
//  BaseVC+Navi.swift
//  ys715
//
//  Created by 宇树科技 on 2021/9/2.
//

import Foundation

// MARK:  页面导航
extension BaseVC {
    class func fromStoryboard(_ identify: String? = nil) -> BaseVC {
        let id = identify ?? String(describing: type(of:self.init()))
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: id) as! BaseVC
        vc.modalPresentationStyle = .fullScreen
        return vc
    }
    
    func pushViewController(_ vc:UIViewController, _ animation:Bool = true) {
        self.dismissType = .push
        if let n = self.navigationController{
            if let baseVC = vc as? BaseVC{
                BaseVC.currentVC = baseVC
            }
            n.pushViewController(vc, animated: animation)
        }else{
            self.present(vc, animated: animation, completion: nil)
        }
    }
    
    func presentViewController(_ vc:UIViewController){
        self.dismissType = .push
        if let baseVC = vc as? BaseVC{
            BaseVC.currentVC = baseVC
        }
        self.present(vc, animated: true, completion: nil)
    }
    
    func pushViewControllerWithHero(_ vc:BaseVC) {
        self.dismissType = .push
        if let n = self.navigationController{
            n.hero.isEnabled = true
            n.pushViewController(vc, animated: true)
            vc.hero.isEnabled = true
        }
    }
    
    func pop(_ animation:Bool = true) -> Void{
        self.dismissType = .pop
        if let n = self.navigationController{
            n.popViewController(animated: animation)
        }else{
            self.dismiss(animated: animation, completion: nil)
        }
    }
    
    /// -1 = 前一个，
    func pop(index:Int) -> Void{
        if let arr = self.navigationController?.children {
            let newIndex = arr.count - 1 + index
            let vc = arr[newIndex]
            self.navigationController?.popToViewController(vc, animated: YES)
            self.dismissType = .pop
        }
    }
}

