//
//  AnimTableVC.swift
//  BaseUtilsDemo
//
//  Created by 李志伟 on 2020/12/11.
//  Copyright © 2020 yimi. All rights reserved.
//

import UIKit

class TempModel:HandyJSON {
    var desc = Date().toString("yyyy-MM-dd HH:mm:ss")
    var hadShowed: Bool = false  //初始值设为false 可以不让cell重复动画
    
    required init() {}
}
    
class AnimTableVC: BaseTableVC<TempModel> {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        initTableView(rect: .zero)
        self.tableview?.delegate = self
        self.tableview?.dataSource = self
        self.ignoreAutoAdjustScrollViewInsets(self.tableview)
        tableview!.bm.addConstraints([.margin(0, 0, 0, 0)])
        initMJHeadView()
        
        self.loadNewDataWithIndicator()
    }
    
    // 模拟请求数据
    override func loadData(_ page: Int) {
        let temp = [TempModel(),TempModel(),TempModel(),TempModel(),TempModel(),TempModel(),TempModel(),TempModel(),TempModel(),TempModel()];
        print("1")
        if page == 1{
            let deadline = DispatchTime.now() + 2
            DispatchQueue.main.asyncAfter(deadline: deadline) {
                self.dataArr = temp
                self.reloadData(1)
                self.finishLoadDate(1)
            }
        }else{
            let deadline = DispatchTime.now() + 2
            DispatchQueue.main.asyncAfter(deadline: deadline) {
                self.dataArr.append(contentsOf: temp)
                self.reloadData(1)
                self.finishLoadDate(1)
            }
        }
    }
    
}

extension AnimTableVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ViewControllerCell.cellFromNib(with: tableView)
        let m = self.dataArr[indexPath.row] as! TempModel
        cell.titleLab.text = m.desc
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ViewControllerCell.cellH
    }
    
    // 顺序渐变显示
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cellModel = self.dataArr[indexPath.row] as! TempModel
        guard cellModel.hadShowed == false else {return}
        cellModel.hadShowed = true
        cell.alpha = 0
        self.linerAnimation(interval: 0.1) {
            UIView.animate(withDuration: 0.5) {
                cell.alpha = 1
            }
        }
    }
}


