//
//  String+Property.swift
//  BaseUtilsDemo
//
//  Created by 宇树科技 on 2021/8/25.
//  Copyright © 2021 yimi. All rights reserved.
//

import Foundation


// 去除字符串首位空格
@propertyWrapper
struct Trimmed {
    private(set) var value: String = ""

    var wrappedValue: String {
        get { value }
        set { value = newValue.trimmingCharacters(in: .whitespacesAndNewlines) }
    }

    init(wrappedValue initialValue: String) {
        self.wrappedValue = initialValue
    }
}


