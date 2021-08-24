//
//  WebVC.swift
//  wangfuAgent
//
//  Created by lzw on 2018/9/19.
//  Copyright © 2018 zhuanbangTec. All rights reserved.
//

import UIKit
import WebKit

class WebVC: BaseVC{

    var urlString :String? = nil
    
    var htmlContent:String? = nil
    
    var barItemColor:UIColor?

    var webView:WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideNav = false
        
        let url = URL(string: urlString!)
        webView.load(URLRequest(url: url!))
    }
    
    override func initUI() {
        webView = WKWebView( frame: CGRect(x:0, y:0, width:KScreenWidth, height:KHeightInNav))
        webView.backgroundColor = .KBGGray
        self.view.addSubview(webView)
        
        let naviView = UIView(frame: CGRect(x: 0, y: 0, width: KScreenWidth, height: KNaviBarH))
        naviView.backgroundColor = .white
        
        if self.navigationController == nil{
            let naviView = UIView(frame: CGRect(x: 0, y: 0, width: KScreenWidth, height: KNaviBarH))
            let lab = UILabel(frame: CGRect(x: 0, y: KNaviBarH-44, width: KScreenWidth, height: 44))
            lab.text = self.title
            lab.textAlignment = .center
            lab.font = UIFont.boldSystemFont(ofSize: 16)
            naviView.addSubview(lab)
            
            let back = UIButton(frame: CGRect(x: 10, y: KNaviBarH-44, width: 50, height: 44))
            back.setImage(UIImage(named: "BMback_Icon"), for: .normal)
            back.tag = 0
            back.addTarget(self, action: #selector(WebVC.back), for: .touchUpInside)
            
            naviView.addSubview(back)
            naviView.backgroundColor = .white
            
            webView.y = KNaviBarH
            
            self.view.addSubview(naviView)
        }
    }

    @objc func myBack(_ btn:UIButton){
        if btn.tag == 0{
            super.back()
        }else{
            let count = webView.backForwardList.backList.count
            bm_print(count)
            if count >= 1{
                webView.goBack()
            }else{
                super.back()
            }
        }
    }
}
