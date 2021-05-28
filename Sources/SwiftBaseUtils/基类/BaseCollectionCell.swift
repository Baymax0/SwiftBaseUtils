//
//  BaseCollectionCell.swift
//  ys715
//
//  Created by 宇树科技 on 2021/5/10.
//

import UIKit

class BaseCollectionCell: UICollectionViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

protocol CustomCollectionCellProtocol {
    static var Identity: String { get }
    static var nib: UINib { get }
    static func cell(_ col:UICollectionView,index:IndexPath) -> Self
}

extension UICollectionViewCell: CustomCollectionCellProtocol{}

extension CustomCollectionCellProtocol{
    static var Identity: String{
        let _Self = self as! UICollectionViewCell.Type
        let Identity = String(describing: _Self.classForCoder())
        return Identity
    }
    static var nib: UINib{
        let _Self = self as! UICollectionViewCell.Type
        let name = String(describing: _Self.classForCoder())
        return UINib.init(nibName: name, bundle: Bundle.main)
    }
    static func cell(_ col:UICollectionView,index:IndexPath) -> Self{
        let cell = col.dequeueReusableCell(withReuseIdentifier: Self.Identity, for: index) as! Self
        return cell
    }
}


extension UICollectionView{
    func registerCell(_ cellClass:UICollectionViewCell.Type){
        self.register(cellClass, forCellWithReuseIdentifier: cellClass.Identity)
    }
    func registerNibCell(_ cellClass:UICollectionViewCell.Type){
        self.register(cellClass.nib, forCellWithReuseIdentifier: cellClass.Identity)
    }
}

