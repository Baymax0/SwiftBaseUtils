//
//  Sting+Utils.swift
//  wangfuAgent
//
//  Created by lzw on 2018/7/18.
//  Copyright © 2018 zhuanbangTec. All rights reserved.
//


extension String{
    var notEmpty: Bool {
        if self.count == 0 {
            return false
        }
        return true
    }
}

// MARK: -  ---------------------- 文字宽高 ------------------------
extension String{
    func stringWidth(_ fontSize:CGFloat) -> CGFloat{
        let font:UIFont = UIFont.systemFont(ofSize: fontSize)
        let attributes = [NSAttributedString.Key.font:font]
        let option = NSStringDrawingOptions.usesLineFragmentOrigin
        let rect:CGRect = self.boundingRect(with: CGSize(width: 2000.0, height: fontSize*1.4), options: option, attributes: attributes, context: nil)
        return rect.size.width
    }
    
    func stringHeight(_ fontSize:CGFloat, width:CGFloat) -> CGFloat{
        let font:UIFont = UIFont.systemFont(ofSize: fontSize)
        let attributes = [NSAttributedString.Key.font:font]
        let option = NSStringDrawingOptions.usesLineFragmentOrigin
        var rect:CGRect!

        if self.count != 0 {
            rect = self.boundingRect(with: CGSize(width: width, height: 2000), options: option, attributes: attributes, context: nil)
        }else{
            rect = " ".boundingRect(with: CGSize(width: width, height: 2000), options: option, attributes: attributes, context: nil)
        }
        return rect.size.height
    }
}

// MARK: -  ---------------------- 文字判断处理 ------------------------
extension String{
    
    /// 用于textviewDelegate里 获得输入后的问字
    mutating func replace(nsRange:NSRange,text:String){
        guard
            let from16 = utf16.index(utf16.startIndex, offsetBy: nsRange.location, limitedBy: utf16.endIndex),
            let to16 = utf16.index(from16, offsetBy: nsRange.length, limitedBy: utf16.endIndex),
            let from = String.Index(from16, within: self),
            let to = String.Index(to16, within: self)
            else { return }
        let range = from ..< to
        self.replaceSubrange(range, with: text)
    }
    
    func substring(_ toIndex:Int) -> String {
        if self.count == 0 {
            return ""
        }
        let index = self.index(self.startIndex, offsetBy: toIndex)
        return String(self.prefix(upTo: index))
    }
    
    
    
    var urlEncode:String?{
        let new = self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        return new
    }

    var image:UIImage?{
        return UIImage(named: self)
    }

    
    ///去除前后空格
    func clearSpace() -> String {
        let s = self.trimmingCharacters(in: .whitespaces)
        return s
    }
    
    /// NSRange转化为range
    func range(from nsRange: NSRange) -> Range<String.Index>? {
        guard
            let from16 = utf16.index(utf16.startIndex, offsetBy: nsRange.location, limitedBy: utf16.endIndex),
            let to16 = utf16.index(from16, offsetBy: nsRange.length, limitedBy: utf16.endIndex),
            let from = String.Index(from16, within: self),
            let to = String.Index(to16, within: self)
            else { return nil }
        return from ..< to
    }
}


