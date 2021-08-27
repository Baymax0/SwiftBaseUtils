//
//  DemoVC4.swift
//  BaseUtilsDemo
//
//  Created by yimi on 2019/10/10.
//  Copyright © 2019 yimi. All rights reserved.
//

import UIKit

class DemoVC4: BaseVC {
    
    var mutiImgView:MultiImgChooseView! = {
        let v = MultiImgChooseView()
        v.numEachRow = 4
        v.tag        = 0
        v.maxNum     = 8
        v.frame      = CGRect(x: 6, y: 0, width: KScreenWidth-12, height: v.imgW)
        v.reload(imgURLArray: nil)
        return v
    }()
    
    @IBOutlet weak var mutiImgBgView: UIView!
    @IBOutlet weak var mutiImgBgViewH: NSLayoutConstraint!
    
    @IBOutlet weak var uploadOneBtn: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        self.initMutiImgView()
    }
    
    // 上传头像
    @IBAction func uploadOneImgAction(_ sender: UIButton) {
        self.chooseSingleImg { (img) in
            self.uploadOneBtn.setImage(img, for: .normal)
            sender.upload(img: img!, showPrograss: YES, complish: { (btn,success, url) in
                if success && btn != nil{
                    print(url!)
                }
            })
        }
    }
    
    
    
    // 配置多图上传
    // 图片上传功能已经写在控件内部
    // 上传 URL 在 ImageApi.upload 中设置
    // 上传 接口 使用 Network.upload 的方法
    // 上传 调用位置 在 UIButton+uploadImg 的扩展方法upload
    func initMutiImgView(){
        // 多图
        mutiImgView.delegate   = self
        mutiImgBgView.addSubview(mutiImgView)
        
        // 初始化图片
        let arr:Array<String> = [];
        mutiImgView.reload(imgURLArray: arr)
    }
    
    
    @IBAction func printImgsStringAction(_ sender: Any) {
        if mutiImgView.imgUrlArray.count != 0 {
            let imgs = mutiImgView.imgUrlArrayString //拿到 上传后的url数据
            print(imgs)
        }
    }
}


// 回调动态修改高度
extension DemoVC4 :MultiImgChooseViewDelegate{
    func setNewImg(itemView view: BMImgItems) {
//        let img = view.img
        print("upload img")
    }
    
    func multiImgChooseView(imgHadChange view: MultiImgChooseView) {
        var row = view.imgBtnArray.count / view.numEachRow
        if view.imgBtnArray.count % view.numEachRow > 0 {
            row = row + 1
        }
        let h = CGFloat(row) * (view.imgW+view.imgBlock)
        
        UIView.animate(withDuration: 0.2) {
            view.frame.size.height = h
            self.mutiImgBgViewH.constant = h
            self.view.layoutIfNeeded()
        }
    }
    
    
}
