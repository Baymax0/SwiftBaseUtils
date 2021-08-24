//
//  ZBJsonString.swift
//  BaseUtilsDemo
//
//  Created by 宇树科技 on 2021/4/14.
//  Copyright © 2021 yimi. All rights reserved.
//

import Foundation
/// data = 字符串
class ZBJsonString: BaseModel {
    var code: Int!
    var msg: String!
    var data: String!
}
// 为BMNetwork提供请求模型的[]方法
extension BMNetwork{
    public subscript(key: BMApiTemplete<String?>) -> BMRequester_String {
        get { return BMRequester_String(key)}
        set { }
    }
}

public class BMRequester_String : BMRequester{
    var api: BMApiTemplete<String?>
    init(_ api: BMApiTemplete<String?>) {
        self.api = api
    }
    
    /// 返回 HandyJSON 对象数组
    /// - Parameters:
    ///   - params: 参数
    ///   - finish: 回调
    @discardableResult
    func request(params:[String:Any]? = nil, finish: @escaping (_ resp:ZBJsonString?)->()) -> DataRequest{
        let url = api.host + api.url
        var withDefault = params ?? [:]
        for (key,value) in api.defaultParam{
            withDefault[key] = value
        }
        return self.requestJson(url, method: api.method, params: withDefault) { (code,jsonStr) in
            let mod = JSONDeserializer<ZBJsonString>.deserializeFrom(json: jsonStr)
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
                let err = ZBJsonString()
                err.code = RequestError.responsDeserializeFalid.rawValue
                err.msg = "网络异常，请求失败"
                finish(err)
            }
        }
    }
    
    
}
