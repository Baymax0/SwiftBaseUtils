//
//  PropertyBaseVC.swift
//  BaseUtilsDemo
//
//  Created by 宇树科技 on 2021/8/25.
//  Copyright © 2021 yimi. All rights reserved.
//

import UIKit



class PropertyBaseVC: BaseVC {

    @Clamping(0...120)
    var age:Int = 18
    
    override func viewDidLoad() {
        super.viewDidLoad()
        age = 999
        print(age)
    }


}



@propertyWrapper struct Clamping<Value:Comparable>{
    var value:Value
    let range: ClosedRange<Value>
    init(wrappedValue value:Value,_ range:ClosedRange<Value>) {
        precondition(range.contains(value))
        self.value = value
        self.range = range
    }
    var wrappedValue:Value{
        get { value }
        set { value = max(min(newValue, range.upperBound), range.lowerBound) }
    }
}







