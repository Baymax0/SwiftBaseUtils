//
//  BMPreviewView.swift
//  BaseUtilsDemo
//
//  Created by 宇树科技 on 2021/9/9.
//  Copyright © 2021 yimi. All rights reserved.
//

import Foundation

class BMPreviewView: UIView{
    
    var bgView:UIView!
    
    var imgUrls:[String]!
    var imgDatas:[UIImage]!
    var collectionView: UICollectionView!
    static let colItemSpacing: CGFloat = 40
    
    var willDismiss:Bool = false
    
    var naviHide:Bool = false
    var navi = UIView()
    var naviLab = UILabel()
    
    // 从0开始
    var currentPageIndex  = -1
    var frontX :CGFloat  = 0
    var nextX  :CGFloat  = 0
    
    override init(frame: CGRect) { super.init(frame: frame) }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    static func createWith(_ imgsUrls:[String], index:Int) -> BMPreviewView{
        let window = UIApplication.shared.windows.filter{$0.isKeyWindow}.first
        let v = BMPreviewView(frame: window!.bounds)
        v.imgUrls = imgsUrls
        v.setPage(index)
        v.initUI()
        return v
    }
    
    static func createWith(_ imgDatas:[UIImage]) -> BMPreviewView{
        let window = UIApplication.shared.windows.filter{$0.isKeyWindow}.first
        let v = BMPreviewView(frame: window!.bounds)
        v.imgDatas = imgDatas
        v.setPage(0)
        v.initUI()
        return v
    }
    
    func initUI(){
        bgView = UIView()
        bgView.backgroundColor = .black
        bgView.bm.add(toView: self, withConstraints: [.fill])
        
        self.backgroundColor = .clear
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        self.collectionView.backgroundColor = .clear
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.isPagingEnabled = true
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.delaysContentTouches = false
        let halfSpacing = BMPreviewView.colItemSpacing / 2
        self.collectionView.bm.add(toView: self, withConstraints: [.top(0), .left(-halfSpacing), .bottom(0), .right(-halfSpacing)])
        self.collectionView.register(BMImagePreviewCell.classForCoder(), forCellWithReuseIdentifier: "BMImagePreviewCell")
        
        navi.frame = CGRect(x: 0, y: 0, width: KScreenWidth, height: KNaviBarH)
        navi.backgroundColor = UIColor.black.alpha(0.2)
        self.addSubview(navi)
        
        naviLab.frame = CGRect(x: 0, y: safeArea_Top, width: KScreenWidth, height: 44)
        naviLab.textAlignment = .center
        naviLab.textColor = .white
        naviLab.font = .boldSystemFont(ofSize: 16)
        navi.addSubview(naviLab)
        
        // 延后执行
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.05) {
            let x = CGFloat(self.currentPageIndex) * (KScreenWidth + BMPreviewView.colItemSpacing)
            self.collectionView.setContentOffset(CGPoint(x: x, y: 0), animated: false)
        }
    }
    
    // 初始化页数
    func setPage(_ page:Int){
        let maxPages = max(imgUrls.count, imgDatas.count)
        var newPage = max(0,page)
        newPage = min(0,maxPages - 1)
        guard currentPageIndex != newPage else { return }

        currentPageIndex = page
        let centerX = CGFloat(currentPageIndex) * (KScreenWidth + BMPreviewView.colItemSpacing)
        frontX = centerX - (KScreenWidth + BMPreviewView.colItemSpacing) * 0.7
        nextX = centerX + (KScreenWidth + BMPreviewView.colItemSpacing) * 0.7
        
        naviLab.text = String(format: "%d / %d", currentPageIndex + 1, maxPages)
    }
    
    func show(){
        let window = UIApplication.shared.windows.filter{$0.isKeyWindow}.first
        self.bm.add(toView: window!, withConstraints: [.fill])
        self.alpha = 0
        UIView.animate(withDuration: 0.3) {
            self.alpha = 1
        } completion: { (_) in }
    }
    
    func hide(){
        UIView.animate(withDuration: 0.3) {
            self.alpha = 0
        } completion: { (_) in
            self.removeFromSuperview()
        }
    }
}

extension BMPreviewView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return max(imgUrls.count, imgDatas.count)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return BMPreviewView.colItemSpacing
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return BMPreviewView.colItemSpacing
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: BMPreviewView.colItemSpacing / 2, bottom: 0, right: BMPreviewView.colItemSpacing / 2)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.bounds.width, height: self.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BMImagePreviewCell", for: indexPath) as? BMImagePreviewCell

        if self.imgUrls.count > 0{
            let str = self.imgUrls[indexPath.row]
            cell?.imageView.kf.setImage(with: str.resource,completionHandler: { (_) in
                cell?.resetSubViewSize()
            })
        }else{
            cell?.imageView.image = self.imgDatas[indexPath.row]
        }
        
        cell?.backgroundColor = .clear
        cell?.singleTapBlock = { [weak self] in
            self?.hide()
        }
        cell?.contentSCScrolled = { [weak self] (cell, y, drogFinished) in
            self?.backPrecent(cell: cell, y: y,drogFinished)
        }
        return cell!
    }
    
    func backPrecent(cell:BMImagePreviewCell, y: CGFloat,_ drogFinished:Bool){
        let absY = y < 0 ? -y : y
        var precent = 1 - absY / 400
        let minScale:CGFloat = 0.75
        precent = max(precent,minScale)
        
        if drogFinished == false{
            if willDismiss == false{
                self.bgView.alpha = precent
                cell.imageView.transform = .init(scaleX: precent, y: precent)
                setNaviHide(true)
            }
        }else{
            if precent == minScale{
                willDismiss = true
                UIView.animate(withDuration: 0.25) {
                    self.bgView.alpha = 0
                    self.collectionView.alpha = 0
                    cell.imageView.transform = .identity
                } completion: { (_) in
                    self.removeFromSuperview()
                }
            }else{
                setNaviHide(false)
                UIView.animate(withDuration: 0.25) {
                    self.bgView.alpha = 1
                    self.collectionView.alpha = 1
                    cell.imageView.transform = .identity
                } completion: { (_) in }
            }
        }
    }
    
    func setNaviHide(_ hide:Bool){
        guard naviHide != hide else { return }
        if hide == true{
            UIView.animate(withDuration: 0.2) {
                self.navi.alpha = 0
            } completion: { (_) in }
        }else{
            UIView.animate(withDuration: 0.2) {
                self.navi.alpha = 1
            } completion: { (_) in }
        }
        naviHide = hide
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentX = scrollView.contentOffset.x
        if currentX < frontX{
            setPage(currentPageIndex - 1)
        }
        if currentX > nextX{
            setPage(currentPageIndex + 1)
        }
    }
}


