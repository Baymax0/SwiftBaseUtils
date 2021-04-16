//
//  BMNetwork.swift
//  BaseUtilsDemo
//
//  Created by 宇树科技 on 2021/4/14.
//  Copyright © 2021 yimi. All rights reserved.
//

import Foundation

enum RequestError : Int{
    case cancel            = -999
    case timeOut            = -1001
    case requestFalid       = -1002
    case serverConnectFalid = -1003
    case noNetwork          = -1009
    case jsonDeserializeFalid   = -2003
    case responsDeserializeFalid   = -2004
    case noMsg  = -9998
    case unknow = -9999

    var msg :String{
        switch  self {
        case .cancel:
            return "请求被取消"
        case .timeOut:
            return "请求超时"
        case .requestFalid:
            return "请求地址无效"
        case .serverConnectFalid:
            return "服务器无法访问"
        case .noNetwork:
            return "无法访问网络"
        case .jsonDeserializeFalid:
            return "数据解析失败"
        case .responsDeserializeFalid:
            return "数据解析失败"
        case .noMsg:
            return ""
        case .unknow:
            return "请求失败"
        }
    }
}

// MARK: -  ---------------------- 基础请求类 ------------------------
public class BMRequester{
    
    static var sessionManager: Alamofire.SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 10
        return Alamofire.SessionManager(configuration: configuration)
    }()
    
    /// 最基础的请求 返回Json
    /// - Parameters:
    ///   - url: url description
    ///   - method: method description
    ///   - params: params description
    ///   - finish: finish description
    @discardableResult
    func requestJson(_ url:String, method:HTTPMethod, params:[String:Any], finish: @escaping (_ code:Int, _ resp:String?)->())  -> DataRequest{
        let dic = params
//        if let session = cache[.sessionId]{
//            dic["sessionId"] = session
//            dic["userId"] = cache[.userId]
//        }
        return BMRequester.sessionManager.request(url, method: method, parameters: dic).responseString { (response) in
            /// 打印请求接口
            self.printResponce(url, dic)
            
            switch response.result{
                case .success(let jsonStr):
                    finish(1,jsonStr)
                case  .failure(let error):
                    let err = self.bundleError(error as NSError)
                    
                    print(" ***** 请求失败： ***** ")
                    print("\(error)")
                    finish(err.rawValue, nil)
            }
        }
    }
    
    func upload(_ img:UIImage, uploading:((_ progress:Double) -> ())?, finish: @escaping (_ imgUrl:String?)->()){
        let newImg = img.fixOrientation()//防止图片被旋转
        let api = BMNetwork.imgUplodeApi
        let imageData = newImg.jpegData(compressionQuality: 0.3)
        let name = "\(Date().toTimeInterval())" + ".jpeg"
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(imageData!, withName: "file", fileName: name, mimeType: "image/jpeg")
        }, to: api){ (encodingResult) in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseString(completionHandler: { (response) in
                    switch response.result{
                    //请求成功
                    case .success(let jsonString):
                        if let resp = JSONDeserializer<ZBJsonDic>.deserializeFrom(json: jsonString) {
                            if resp.code == 1{
                                let data = resp.data
                                if let url = data?["url"] as? String{
                                    print(url)
                                    finish(url)
                                }else{
                                    finish(nil)
                                }
                            }else{
                                finish(nil)
                            }
                        }else{
                            finish(nil)
                        }
                    //常见 访问失败 原因
                    case .failure(let error ):
                        print(error)
                        finish(nil)
                    }
                })
                //获取上传进度
                upload.uploadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
                    DispatchQueue.main.sync {
                        uploading?(progress.fractionCompleted)
                    }
                }
            case .failure(_):
                finish(nil)
            }
        }
    }
    
    // 打印接口响应
    private func printResponce(_ url:String, _ params:[String:Any]){
        var allUrl = url
        if params.keys.count != 0{
            var count = 0
            for key in params.keys{
                if count == 0{
                    allUrl = allUrl + "?"
                }else{
                    allUrl = allUrl + "&"
                }
                let val = params[key]
                let valStr = String(describing: val!)
                allUrl = allUrl + "\(key)=\(valStr)"
                count += 1
            }
        }
        print("----------------------")
        print(allUrl)
    }
    
    func handelResponce(code:Int?){
        // 重新登录
        if code == 2{
            Hud.showText("登录失效，请重新登录")
            Hud.runAfterHud {
                noti.post(name: .needRelogin, object: nil)
            }
        }
    }
    
    func bundleError(_ err:NSError) -> RequestError{
        switch err.code{
        case -999:
            return .cancel
        case -1001:
            return .timeOut
        case -1002:
            return .requestFalid
        case -1003:
            return .serverConnectFalid
        case -1009:
            return .noMsg
        case 4:
            return .responsDeserializeFalid
        default:
            print("未处理的 error code:\(err.code)\n \(err)")
            return .unknow
        }
    }
}
