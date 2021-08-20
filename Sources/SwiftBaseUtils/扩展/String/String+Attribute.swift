//
//  String+Attribute.swift
//  ys715
//
//  Created by 宇树科技 on 2021/8/18.
//

import Foundation

var BM_Global_Att_Str : NSMutableAttributedString?
var BM_Global_Att_Dic : [NSAttributedString.Key :Any]?

extension String {
    var attribute:NSMutableAttributedString{
        BM_Global_Att_Str = NSMutableAttributedString(string: self)
        BM_Global_Att_Dic = [:]
        return BM_Global_Att_Str!
    }
    
    func lineSpace(_ lineSpace:CGFloat) -> NSMutableAttributedString{
        var arr : [NSAttributedString.Key:Any] = [:]
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpace
        arr[.paragraphStyle] = paragraphStyle
        BM_Global_Att_Str!.addAttributes(arr, range: NSMakeRange(0, BM_Global_Att_Str!.length))
        BM_Global_Att_Dic![.paragraphStyle] = paragraphStyle
        return BM_Global_Att_Str!
    }
    
    func font(_ font:UIFont,_ range:(Int,Int)? = nil) -> NSMutableAttributedString {
        var arr : [NSAttributedString.Key:Any] = [:]
        arr[.font] = font
        BM_Global_Att_Dic![.font] = font
        let start = range?.0 ?? 0
        let length = range?.1 ?? BM_Global_Att_Str!.length
        BM_Global_Att_Str!.addAttributes(arr, range: NSMakeRange(start, length))
        return BM_Global_Att_Str!
    }
    
    func color(_ color:UIColor,_ range:(Int,Int)? = nil) -> NSMutableAttributedString {
        var arr : [NSAttributedString.Key:Any] = [:]
        arr[.foregroundColor] = color
        let start = range?.0 ?? 0
        let length = range?.1 ?? BM_Global_Att_Str!.length
        BM_Global_Att_Str!.addAttributes(arr, range: NSMakeRange(start, length))
        return BM_Global_Att_Str!
    }
}

extension NSMutableAttributedString {
    func lineSpace(_ lineSpace:CGFloat) -> NSMutableAttributedString{
        var arr : [NSAttributedString.Key:Any] = [:]
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpace
        arr[.paragraphStyle] = paragraphStyle
        BM_Global_Att_Str!.addAttributes(arr, range: NSMakeRange(0, BM_Global_Att_Str!.length))
        return BM_Global_Att_Str!
    }
    
    func font(_ font:UIFont,_ range:(Int,Int)? = nil) -> NSMutableAttributedString {
        var arr : [NSAttributedString.Key:Any] = [:]
        arr[.font] = font
        let start = range?.0 ?? 0
        let length = range?.1 ?? BM_Global_Att_Str!.length
        BM_Global_Att_Str!.addAttributes(arr, range: NSMakeRange(start, length))
        return BM_Global_Att_Str!
    }
    
    func color(_ color:UIColor,_ range:(Int,Int)? = nil) -> NSMutableAttributedString {
        var arr : [NSAttributedString.Key:Any] = [:]
        arr[.foregroundColor] = color
        let start = range?.0 ?? 0
        let length = range?.1 ?? BM_Global_Att_Str!.length
        BM_Global_Att_Str!.addAttributes(arr, range: NSMakeRange(start, length))
        return BM_Global_Att_Str!
    }
    
    func textH(_ sizeW:CGFloat) -> CGFloat{
        let size = CGSize(width: sizeW, height: 4000)
        let stringSize = self.string.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: BM_Global_Att_Dic, context: nil)
        return stringSize.height
    }
}
