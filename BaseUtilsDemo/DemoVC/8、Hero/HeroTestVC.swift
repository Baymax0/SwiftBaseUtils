//
//  HeroTestVC.swift
//  BaseUtilsDemo
//
//  Created by 宇树科技 on 2021/11/2.
//  Copyright © 2021 yimi. All rights reserved.
//

import UIKit

class HeroTestVC: BaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        // 测滑 进度返回
        self.addScreenEdgePan()
    }


    
}


//MARK: ------------ transion ------------
extension PlanDetailVC{
    func addScreenEdgePan(){
        self.popGestureEnable = false
        let screenEdgePanGR = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handlePan(gr:)))
        screenEdgePanGR.edges = .left
        view.addGestureRecognizer(screenEdgePanGR)
    }
    
    @objc func handlePan(gr: UIPanGestureRecognizer) {
        guard heroFinished == false else {
            return
        }
        let progress = gr.translation(in: nil).x / KScreenWidth
        switch gr.state {
        case .began:
            self.back()
        case .changed:
            if progress > 0.15{
                heroFinished = true
                Hero.shared.finish()
            }else{
                Hero.shared.update(progress)
            }
        default:
            if progress > 0.15{
                heroFinished = true
                Hero.shared.finish()
            }else{
                Hero.shared.cancel()
            }
        }
    }
}
