//
//  UIlabel+SpaceLine.swift
//  ys715
//
//  Created by 宇树科技 on 2021/7/26.
//

import Foundation
import UIKit

extension UILabel{
    
    func setTextWithLineSpace(_ text:String, lineSpace:CGFloat = 8, width:CGFloat? = nil) -> CGFloat{
        
        var arr : [NSAttributedString.Key:Any] = [:]
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpace
        arr[.paragraphStyle] = paragraphStyle
        arr[.font] = self.font

        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttributes(arr, range: NSMakeRange(0, attributedString.length))
        self.attributedText = attributedString
        
        let sizeW = width ?? self.w
        let size = CGSize(width: sizeW, height: 1000)
        let stringSize = text.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: arr, context: nil)
        return stringSize.height
    }
    
}

