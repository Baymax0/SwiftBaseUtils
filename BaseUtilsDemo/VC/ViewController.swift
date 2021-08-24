//
//  ViewController.swift
//  BaseUtilsDemo
//
//  Created by yimi on 2019/5/24.
//  Copyright © 2019 yimi. All rights reserved.
//

import UIKit
import Kingfisher
import Hero

class ItemModel {
    var title: String! = ""
    var desc: String! = ""
    
    init(_ title:String, _ desc:String) {
        self.title = title
        self.desc = desc
    }
}


class ViewController: BaseTableVC {
    
    override func viewDidLoad() {
        self.hideNav = true
        
        initTableView(rect: .zero)
        self.tableview?.delegate = self
        self.tableview?.dataSource = self
        self.ignoreAutoAdjustScrollViewInsets(self.tableview)
        tableview?.bm.addConstraints([.margin(KNaviBarH, 0, 0, 0)])
        
        self.dataArr = [
            ItemModel("1、maskView使用","遮照视图maskView，全屏显示一些自定义弹出view"),
            ItemModel("2、cell动画","cell渐变显示"),
            ItemModel("3、PickerVC","选择框使用"),
            ItemModel("4、图片预览","图片点击放大预览"),
            ItemModel("5、按钮动画","点赞按钮点击效果"),
            ItemModel("6、CollectionKit",""),
        ]
        self.tableview?.reloadData()
    }
    
    @IBAction func reloadAction(_ sender: Any!) {}
    
}

extension ViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ViewControllerCell.cellH
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ViewControllerCell.cellFromNib(with: tableView)
        cell.backgroundColor = .white
        if let m = self.dataArr[indexPath.row] as? ItemModel{
            cell.titleLab.text = m.title
            cell.detailLab.text = m.desc
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            let vc = MaskViewUsedVC()
            self.pushViewController(vc)
        }
        if indexPath.row == 1{
            let vc = AnimTableVC()
            self.pushViewController(vc)
        }
        if indexPath.row == 2{
            let vc = PickerVC()
            self.pushViewController(vc)
        }
        if indexPath.row == 3{
            let vc = DemoVC1()
            self.pushViewController(vc)
        }
        if indexPath.row == 4{
            let vc = BtnClickAnimVC()
            self.pushViewController(vc)
        }
        if indexPath.row == 5{
            let vc = CollectionViewVC()
            self.pushViewController(vc)
        }
        
        
    }
    
}


