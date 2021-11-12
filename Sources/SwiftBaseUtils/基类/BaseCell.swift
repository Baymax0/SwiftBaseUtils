//
//  BaseCell.swift
//  wenzhuanMerchants
//
//  Created by 李志伟 on 2020/7/15.
//  Copyright © 2020 baymax. All rights reserved.
//



class BaseCell: UITableViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
}


protocol CustomCellProtocol {
    static func cellFromNib(with table:UITableView, customIdentity:String?) -> Self
    static func cell(with table:UITableView) -> Self
}

extension CustomCellProtocol{
    static func cellFromNib(with table:UITableView, customIdentity:String? = nil) -> Self{
        let type = self as! UITableViewCell.Type
        let name = String(describing: type.classForCoder())
        var cell = table.dequeueReusableCell(withIdentifier: customIdentity ?? name) as? Self
        if cell == nil {
            let nib  = UINib(nibName: name, bundle: nil)
            table.register(nib, forCellReuseIdentifier: customIdentity ?? name)
            cell = (table.dequeueReusableCell(withIdentifier: customIdentity ?? name)) as? Self
        }
        return cell!
    }
    
    
    static func cell(with table:UITableView) -> Self{
        let type = self as! UITableViewCell.Type
        let Identity = String(describing: type.classForCoder())
        var cell = table.dequeueReusableCell(withIdentifier: Identity) as? Self
        if cell == nil {
            table.register(type, forCellReuseIdentifier: Identity)
            cell = table.dequeueReusableCell(withIdentifier: Identity) as? Self
        }
        return cell!
    }
}

extension UITableViewCell:CustomCellProtocol{
    static var nib:UINib{
        let name = String(describing: self.classForCoder())
        return UINib.init(nibName: name, bundle: Bundle.main)
    }
}



