//
//  BMApiSet.swift
//  BaseUtilsDemo
//
//  Created by 宇树科技 on 2021/4/14.
//  Copyright © 2021 yimi. All rights reserved.
//

import Foundation


///     配置示例：
///
///     //服务器地址
///     public class WangFuApi<ValueType> : BMApiTemplete<ValueType> {
///         var host: String = "http://163.gg"
///     }
///     //接口
///     extension BMApiSet {
///         static let login = WangFuApi<LoginModel?>("/api/login")
///         static let list = WangFuApi<Array<LoginModel>?>("/api/list")
///     }
///
///     使用：
///     network[.login].request(params: nil) { (resp) in
///         if resp?.code == 1{
///             let model = resp?.data
///             print("\(model)")
///         }
///      }
///     再也不用在调方法的时候传 Model.self 了
///
///

// MARK: -  ---------------------- 需要重写或者扩展的 ------------------------

// 外部用来 extension 该类 添加接口
public class BMApiSet {
    fileprivate init() {}
}

//
public class BMApiTemplete<ValueType> : BMApiSet{

    var method: HTTPMethod = .get
    var host: String{ return "" }

    let url: String

    var urlWithHost:String{
        return self.host + self.url
    }
    
    var defaultParam:Dictionary<String, Any> {
        return [:]
    }
    
    public init(_ url: String) {
        self.url = url
        super.init()
    }
}

