//
//  PickerVC.swift
//  BaseUtilsDemo
//
//  Created by 李志伟 on 2020/12/24.
//  Copyright © 2020 yimi. All rights reserved.
//

import UIKit

class PickerVC: BaseVC {

    var picker:BMBasePicker!
    
    var timeIntervalPicker:BMTimeIntervalPicker!

    @IBOutlet weak var chooseLab1: UILabel!
    @IBOutlet weak var chooseLab2: UILabel!
    @IBOutlet weak var chooseLab2_2: UILabel!
    @IBOutlet weak var chooseLab3: UILabel!
    @IBOutlet weak var chooseLab4: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
   }

    // 单选框
    @IBAction func chooseAction(_ sender: UIButton) {
        picker = BMPicker.singlePicker(["包子","馒头"], 0, { (index) in
            if index == 0{
                self.chooseLab1.text = "包子"
            }else{
                self.chooseLab1.text = "馒头"
            }
        })
        //如果遇到按钮无法点击，就在当前vc重写addTarget
//        picker.confirmBtn.addTarget(self, action: #selector(comfirm), for: .touchUpInside)
//        picker.bgMaskView.addTarget(self, action: #selector(close), for: .touchUpInside)
        picker.show()
    }
    
    // 选择时间1
    @IBAction func chooseTimeAction(_ sender: UIButton) {
        picker = BMPicker.datePicker(currentTime: Date(), startTime: nil, endTime: nil) { (date) in
            self.chooseLab2.text = date!.toString("yyyy-MM-dd")
        }
        picker.show()
    }
    
    // 选择时间2(自定义选择格式)
    @IBAction func chooseTime2Action(_ sender: UIButton) {
        let picker = BMDatePicker({ (d) in
            self.chooseLab2_2.text = d!.toString()
        })
        self.picker = picker
        picker.datePickMode = .hms
        picker.date = Date(timeIntervalSinceNow: 0)
        picker.show()
    }
    
    
    // 选择时间段
    @IBAction func chooseTimeInterval(_ sender: UIButton) {
        timeIntervalPicker = BMTimeIntervalPicker.share()
        timeIntervalPicker.startTime = Date()
        timeIntervalPicker.endTime = Date()
        timeIntervalPicker.setCallBack { (pick) -> (Bool) in
            let str = pick.startTime.toString("yyyy-MM-dd") + "~" + pick.endTime.toString("yyyy-MM-dd")
            self.chooseLab3.text = str
            return true
        }
        timeIntervalPicker.show()
    }
    
    // 选择位置
    @IBAction func chooseLocaAction(_ sender: UIButton) {
        picker = BMPicker.cityPicker {(arr) in
            var str = ""
            for address in arr{
                str = "\(str)\(address.name!) "
            }
            self.chooseLab4.text = str
        }
        picker.show()
    }


}
