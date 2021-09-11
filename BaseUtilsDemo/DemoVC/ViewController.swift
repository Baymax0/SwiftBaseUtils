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
import HandyJSON

class ItemModel: HandyJSON {
    required init() {}
    
    var title: String! = ""
    var desc: String! = ""
    
    init(_ title:String, _ desc:String) {
        self.title = title
        self.desc = desc
    }
}


class ViewController: BaseTableVC<ItemModel> {
    
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
            ItemModel("7、属性修饰器","@propertyWrapper的使用，批量设置GetSet方法"),
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
        let m = self.dataArr[indexPath.row]
        cell.titleLab.text = m.title
        cell.detailLab.text = m.desc
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var vc:BaseVC?
        if indexPath.row == 0{
            vc = MaskViewUsedVC() }
        if indexPath.row == 1{
            vc = AnimTableVC() }
        if indexPath.row == 2{
            vc = PickerVC() }
        if indexPath.row == 3{
            vc = DemoVC1() }
        if indexPath.row == 4{
            vc = BtnClickAnimVC() }
        if indexPath.row == 5{
            vc = CollectionViewVC() }
        if indexPath.row == 6{
            vc = PropertyBaseVC() }
        
        
        if vc != nil{
            self.pushViewController(vc!)
        }
    }
}


