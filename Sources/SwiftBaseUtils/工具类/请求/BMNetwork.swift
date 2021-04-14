//
//  Network.swift
//  wenzhuan
//
//  Created by 李志伟 on 2020/5/21.
//  Copyright © 2020 baymax. All rights reserved.
//


let network = BMNetwork()
public class HTMLString {}

// MARK: -  ---------------------- 实现 network[.接口] 的调用方式------------------------
public class BMNetwork{
    
    //可以通过 BMNetwork.imgUplodeApi = “”修改
    static var imgUplodeApi = ""
    
    @discardableResult
    func requestJson(_ url:String, method:HTTPMethod, params:[String:Any], finish: @escaping (_ code:Int, _ resp:String?)->())  -> DataRequest{
        BMRequester().requestJson(url, method: method, params: params, finish: finish)
    }
    
    func upload(_ img:UIImage, uploading:((_ progress:Double) -> ())?, finish: @escaping (_ imgUrl:String?)->()){
        BMRequester().upload(img, uploading: uploading, finish: finish)
    }
    
    public subscript(key: BMApiTemplete<HTMLString?>) -> BMRequester_Json {
        get { return BMRequester_Json(key)}
        set { }
    }
}
 






public class BMRequester_Json : BMRequester{
    
    
    var api: BMApiTemplete<HTMLString?>
    init(_ api: BMApiTemplete<HTMLString?>) {
        self.api = api
    }
    
    @discardableResult
    func requestJson(params:[String:Any]? = nil, finish: @escaping (_ json:String?)->()) -> DataRequest {
        let url = api.host + api.url
        var withDefault = params ?? [:]
        for (key,value) in api.defaultParam{
            withDefault[key] = value
        }
        return self.requestJson(url, method: api.method, params: withDefault)  { (code,jsonStr) in
            finish(jsonStr)
        }
    }
}
