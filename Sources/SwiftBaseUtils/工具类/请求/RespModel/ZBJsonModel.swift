//
//  ZBJsonModel.swift
//  BaseUtilsDemo
//
//  Created by 宇树科技 on 2021/4/14.
//  Copyright © 2021 yimi. All rights reserved.
//

import Foundation
class BaseModel:  HandyJSON{
    required init() { }
}
/// data = 模型
class ZBJsonModel<T:HandyJSON>: BaseModel {
    var code: Int!
    var msg: String!
    var data: T?
}

// 为BMNetwork提供请求模型的[]方法
extension BMNetwork{
    public subscript<T:HandyJSON>(key: BMApiTemplete<T?>) -> BMRequester_Model<T> {
        get { return BMRequester_Model(key)}
        set { }
    }
}

// MARK: -  ---------------------- 封装了返回类型的请求类 ------------------------
public class BMRequester_Model<T:HandyJSON>: BMRequester{

    var api:BMApiTemplete<T?>

    public init(_ api:BMApiTemplete<T?>) {
        self.api = api
    }
    
    /// 返回 HandyJSON 对象
    /// - Parameters:
    ///   - params: 参数
    ///   - finish: 回调
    @discardableResult
    func request(params:[String:Any]? = nil, finish: @escaping (_ resp:ZBJsonModel<T>?)->()) -> DataRequest{
        let url = api.host + api.url
        var withDefault = params ?? [:]
        for (key,value) in api.defaultParam{
            withDefault[key] = value
        }
        
        return self.requestJson(url, method: api.method, params: withDefault) { (code,jsonStr) in
            if jsonStr == nil{
                let err = ZBJsonModel<T>()
                err.code = code
                err.msg = "网络异常，请求失败"
                finish(err)
                return
            }
            let mod = JSONDeserializer<ZBJsonModel<T>>.deserializeFrom(json: jsonStr)
            if mod != nil{
                print("code:\(mod!.code ?? -99)")
                print("msg:\(mod!.msg ?? "")")
                print("data:\(jsonStr ?? ""))")
                self.handelResponce(code: mod?.code)
                finish(mod)
            }else{
                print(" ***** 解析失败： ***** ")
                if jsonStr != nil{
                    print(jsonStr!)
                }else{
                    print("解析失败")
                }
                let err = ZBJsonModel<T>()
                err.code = RequestError.responsDeserializeFalid.rawValue
                err.msg = "网络异常，请求失败"
                finish(err)
            }
        }
    }
    
    
}


