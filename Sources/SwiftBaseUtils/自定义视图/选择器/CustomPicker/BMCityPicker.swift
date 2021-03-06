//
//  BMCityPicker.swift
//  wangfuAgent
//
//  Created by lzw on 2018/7/27.
//  Copyright © 2018 zhuanbangTec. All rights reserved.
//


class BMCityPicker: BMBasePicker {

    var provinceModel:Address?
    var cityModel:Address?
    var districtModel:Address?

    var provinceArray:Array<Address>!
    var cityArray:Array<Address>!
    var districtArray:Array<Address>!

    var changed: ((_:Array<Address>)->())?
    var selected: ((_:Array<Address>)->())

    init(_ provinceId:Int64?,_ cityId:Int64?,_ districtId:Int64?, _ selected:@escaping(_:Array<Address>)->(), _ changed:((_:Array<Address>)->())? = nil) {
        self.selected = selected
        self.changed = changed
        super.init()

        self.pickerView.dataSource = self
        self.pickerView.delegate = self
        
        //初始化数据
        provinceArray = CityDBManager.share.getProvinceList()
        cityArray = Array<Address>()
        districtArray = Array<Address>()
        
        self.chooseProvince(0)
        for (index,model) in provinceArray.enumerated(){
            if model.ID == provinceId{
                self.chooseProvince(index)
                break
            }
        }
        for (index,model) in cityArray.enumerated(){
            if model.ID == cityId{
                self.chooseCity(index)
                break
            }
        }
        for (index,model) in districtArray.enumerated(){
            if model.ID == districtId{
                self.chooseDistrict(index)
                break
            }
        }
        self.setContentH(240)
        self.rowH = 35

    }
    
    init(_ provinceId:Int64?,_ cityId:Int64?, _ selected:@escaping(_:Array<Address>)->(), _ changed:((_:Array<Address>)->())? = nil) {
        self.selected = selected
        self.changed = changed
        super.init()

        self.pickerView.dataSource = self
        self.pickerView.delegate = self
        
        //初始化数据
        provinceArray = CityDBManager.share.getProvinceList()
        cityArray = Array<Address>()
        districtArray = nil
        
        self.chooseProvince(0)
        for (index,model) in provinceArray.enumerated(){
            if model.ID == provinceId{
                self.chooseProvince(index)
                break
            }
        }
        for (index,model) in cityArray.enumerated(){
            if model.ID == cityId{
                self.chooseCity(index)
                break
            }
        }
        self.setContentH(240)
        self.rowH = 35
    }
    
    
    required init?(coder aDecoder: NSCoder) {   fatalError("init(coder:) has not been implemented") }

    func chooseProvince(_ index:Int){
        provinceModel = provinceArray[index]
        if bgLab.isHidden == false{
            bgLab.text = provinceModel?.shortName
        }
        cityArray = CityDBManager.share.getCityList(self.provinceModel!.ID!)
        pickerView.selectRow(index, inComponent: 0, animated: NO)
        pickerView.reloadComponent(1)
        chooseCity(0)
    }
    
    func chooseCity(_ index:Int){
        pickerView.selectRow(index, inComponent: 1, animated: NO)
        cityModel = cityArray[index]
        if districtArray != nil{
            districtArray = CityDBManager.share.getDistrictList(self.cityModel!.ID!)
            pickerView.reloadComponent(2)
            chooseDistrict(0)
        }
    }
    
    func chooseDistrict(_ index:Int){
        pickerView.selectRow(index, inComponent: 2, animated: NO)
        if index >= districtArray.count {
            districtModel = nil
        }else{
            districtModel = districtArray[index]
        }
    }

}

// MARK: - 重写的方法
extension BMCityPicker{

    override func comfirm(){
        super.comfirm()
        if districtModel != nil{
            selected([provinceModel!,cityModel!,districtModel!])
        }else{
            selected([provinceModel!,cityModel!])
        }
    }

    override func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if districtArray == nil{
            if cityArray == nil{
                return 1
            }else{
                return 2
            }
        }
        return 3
    }
    override func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return provinceArray.count
        }
        else if component == 1 {
            return cityArray.count
        }
        else{
            return districtArray.count
        }
    }

    override func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return rowH
    }

    override func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return provinceArray[row].name
        }
        else if component == 1 {
            return cityArray[row].name
        }
        else{
            return districtArray[row].name
        }
    }

    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel = view as? UILabel

        if pickerLabel == nil{
            pickerLabel = UILabel()
            pickerLabel!.textAlignment = .center
            pickerLabel!.adjustsFontSizeToFitWidth = YES
            pickerLabel!.backgroundColor = .clear
            pickerLabel!.font = UIFont.systemFont(ofSize: 16)
        }
        pickerLabel!.text=self.pickerView(pickerView, titleForRow: row, forComponent: component)
        return pickerLabel!
    }

    override func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            self.chooseProvince(row)
        }
        else if component == 1 {
            self.chooseCity(row)
        }
        else{
            self.chooseDistrict(row)
        }
    }
}








