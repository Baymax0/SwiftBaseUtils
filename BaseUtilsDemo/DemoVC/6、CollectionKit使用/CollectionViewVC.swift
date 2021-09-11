//
//  CollectionViewVC.swift
//  BaseUtilsDemo
//
//  Created by 李志伟 on 2020/12/25.
//  Copyright © 2020 yimi. All rights reserved.
//

import Foundation
import UIKit

class CollectionViewVC: BaseVC{
    
    var collectionView:CollectionView!
    var dataSource: ArrayDataSource<Int>!
    var viewSource: ClosureViewSource<Int,UILabel>!
    var provider: BasicProvider<Int, UILabel>!
    
    var picker:BMSinglePicker!
    
    
    override func viewDidLoad() {
        self.view.backgroundColor = .KBGGray
        
        collectionView = CollectionView(frame: .init(x: 0, y: 200, width: KScreenWidth, height: 100))
        self.view.addSubview(collectionView)
        
        // 数据数组
        dataSource = ArrayDataSource(data: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10])
        // cell内容
        viewSource = ClosureViewSource(viewUpdater: { (view: UILabel, data: Int, index: Int) in
            view.backgroundColor = #colorLiteral(red: 1, green: 0.8451469541, blue: 0.861125946, alpha: 1)
            view.layer.cornerRadius = 9
            view.layer.masksToBounds = true
            view.text = "\(data)"
            view.textAlignment = .center
            view.font = .boldSystemFont(ofSize: 19)
            view.textColor = #colorLiteral(red: 0.8415004611, green: 0.2267866731, blue: 0.2883485854, alpha: 1)
            print("show \(index)")
        })
        // cell尺寸
        let sizeSource = { (index: Int, data: Int, collectionSize: CGSize) -> CGSize in
            if index < 4{
                return CGSize(width: KScreenWidth - 80, height: 90)
            }else{
                return CGSize(width: KScreenWidth - 80, height: 90)
            }
        }
        provider = BasicProvider(dataSource: dataSource, viewSource: viewSource, sizeSource: sizeSource)
        // 布局
        provider.layout = FlowLayout(spacing: 10, justifyContent: .center)
        provider.animator = MyAnimator()
        collectionView.provider = provider
        collectionView.isPagingEnabled = true
    }

    @IBAction func addAction() {
        self.dataSource.data.append(Date().toString("ss").toInt())
    }
    
    @IBAction func deleteAction() {
        if dataSource.data.count > 0{
            dataSource.data.removeLast()
        }
    }
    
    @IBAction func changeAnimator(_ sender: UIButton) {
        let arr = ["SimpleAnimator","FadeAnimator","ScaleAnimator","MyAnimator"]
        picker = BMPicker.singlePicker(arr, 0) { (index) in
            if index == 0{
                self.provider.animator = SimpleAnimator()}
            if index == 1{
                self.provider.animator = FadeAnimator()}
            if index == 2{
                self.provider.animator = ScaleAnimator()}
            //可根据FadeAnimator 继承 SimpleAnimator 自定义动画
            if index == 2{
                self.provider.animator = MyAnimator()}
        }
        picker.show()
    }
    
}
