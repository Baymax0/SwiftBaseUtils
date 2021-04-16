//
//  UIView+Extension.swift
//  LoveStory
//
//  Created by 宇树科技 on 2021/4/16.
//

import Foundation
import UIKit

extension UIView{
    func addShadow(_ cornerRadius:CGFloat! = 8){
        if cornerRadius != nil{
            self.layer.cornerRadius = cornerRadius
        }
        self.layer.shadowColor = #colorLiteral(red: 0.703776896, green: 0.7038969398, blue: 0.7037611604, alpha: 1).cgColor
        self.layer.shadowOpacity = 0.3
        self.layer.shadowRadius = 4
        self.layer.shadowOffset = CGSize(width: 2, height: 2)
    }
    
    func addShadow(_ cornerRadius:CGFloat! = 8, _ opacity: Float){
        if cornerRadius != nil{
            self.layer.cornerRadius = cornerRadius
        }
        self.layer.shadowColor = #colorLiteral(red: 0.703776896, green: 0.7038969398, blue: 0.7037611604, alpha: 1).cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = 4
        self.layer.shadowOffset = CGSize(width: 2, height: 2)
    }
}
