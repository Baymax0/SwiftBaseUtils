//
//  ZBJsonArrayModel.swift
//  BaseUtilsDemo
//
//  Created by 宇树科技 on 2021/4/14.
//  Copyright © 2021 yimi. All rights reserved.
//

import Foundation
/// data = 模型数组
class ZBJsonArrayModel<T:HandyJSON>: BaseModel {
    var code: Int!
    var msg: String!
    var data: Array<T>?
}


// 为BMNetwork提供请求模型的[]方法
extension BMNetwork{
    public subscript<T:HandyJSON>(key: BMApiTemplete<Array<T>?>) -> BMRequester_ModelList<T> {
        get { return BMRequester_ModelList(key)}
        set { }
    }
}

public class BMRequester_ModelList<T:HandyJSON> : BMRequester{

    var api: BMApiTemplete<Array<T>?>

    init(_ api: BMApiTemplete<Array<T>?>) {
        self.api = api
    }
    /// 返回 HandyJSON 对象数组
    /// - Parameters:
    ///   - params: 参数
    ///   - finish: 回调
    @discardableResult
    func request(params:[String:Any]? = nil, finish: @escaping (_ resp:ZBJsonArrayModel<T>?)->()) -> DataRequest{
        let url = api.host + api.url
        var withDefault = params ?? [:]
        for (key,value) in api.defaultParam{
            withDefault[key] = value
        }
        return self.requestJson(url, method: api.method, params: withDefault) { (code,jsonStr) in
            if jsonStr == nil{
                let err = ZBJsonArrayModel<T>()
                err.code = code
                err.msg = "网络异常，请求失败"
                finish(err)
                return
            }
            var mod = JSONDeserializer<ZBJsonArrayModel<T>>.deserializeFrom(json: jsonStr)
            // 为其他App做适配，外面不套ZBJson***再解析一次
            if mod == nil{
                if let data = [T].deserialize(from: jsonStr) as? [T]{
                    mod = ZBJsonArrayModel<T>()
                    mod?.code = 1
                    mod?.data = data
                }
            }
            
            if mod != nil{
                bm_print("code:\(mod!.code ?? -99)")
                bm_print("msg:\(mod!.msg ?? "")")
                bm_print("data:\(String(describing: jsonStr!)))")
                self.handelResponce(code: mod?.code)
                finish(mod)
            }else{
                bm_print(" ***** 解析失败： ***** ")
                if jsonStr != nil{
                    bm_print(jsonStr!)
                }else{
                    bm_print("请求失败")
                }
                let err = ZBJsonArrayModel<T>()
                err.code = RequestError.responsDeserializeFalid.rawValue
                err.msg = "网络异常，请求失败"
                finish(err)
            }
        }
    }
}
