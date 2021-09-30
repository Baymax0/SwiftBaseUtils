//
//  CycleView.swift
//  saasSwift
//
//  Created by 周玉 on 2017/11/21.
//  Copyright © 2017年 周玉. All rights reserved.
//

import UIKit

//图片的模式
enum contentMode {
    case scaleAspectFill
    case scaleAspectFit
}

protocol CycleViewDelegate : class {
    func cycleViewDidSelectedItemAtIndex(_ index : NSInteger) -> ()
}


class CycleView: UIView,UICollectionViewDelegate, UICollectionViewDataSource {
    
    //MARK: ------------ Required ------------
    public var imageURLStringArr : [String]! = []// 设置图片
    public weak var delegate : CycleViewDelegate? // 代理 点击事件
    
    
    //MARK: ------------ 样式设置 ------------
    public var mode         : contentMode?  = .scaleAspectFill// 图片显示的mode
    public var contentInset : UIEdgeInsets  = .zero
    public var showPageControl  : Bool = false
    public var currentPageColor : UIColor? { didSet{ pageControl.currentPageIndicatorTintColor = currentPageColor } }
    public var pageColor        : UIColor? { didSet{ pageControl.pageIndicatorTintColor        = pageColor } }
    public var moveTimeinterval  : Int = 4 // 轮播时间间隔
    public var imageCornerRedius : Int = 0 //

    public func reloadView(){
        guard imageURLStringArr.count != 0 else {
            collectionView.isHidden = true
            return
        }
        collectionView.isHidden = false
        
        if showPageControl == false{
            pageControl.isHidden = true
        }else{
            pageControl.isHidden = imageURLStringArr.count == 1
            pageControl.numberOfPages = (imageURLStringArr?.count)!
        }

        collectionView.reloadData()
        collectionView.isScrollEnabled = imageURLStringArr!.count > 1
        
        //滚动到中间位置
        if imageURLStringArr!.count > 1{
            let indexPath : IndexPath = IndexPath(item: (imageURLStringArr?.count)! * KCount, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .left, animated: true)
        }
    }
    
    public func stop(){
        self.timer.invalidate()
        self.timer = nil
    }
    
    
    //MARK: ------------ init ------------
    fileprivate let KCount = 100
    fileprivate var collectionView : UICollectionView!
    fileprivate var pageControl    : UIPageControl!
    fileprivate var timer        : Timer!
    fileprivate var timeCounting : Int = 0

    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

//MARK: 轮播逻辑处理
extension CycleView {
    //MARK: 更新定时器 获取当前位置,滚动到下一位置
    @objc func updateTimer() -> Void {
        // 单图不轮播
        guard imageURLStringArr != nil && imageURLStringArr!.count > 1 else { return }
        // 为0 不轮播
        guard moveTimeinterval != 0 else { return }
        
        // 秒数记述为0时触发轮播
        timeCounting = (timeCounting + 1) % moveTimeinterval
        guard timeCounting == 0 else { return }

        let indexPath = collectionView.indexPathsForVisibleItems.last
        guard indexPath != nil else { return }
        let nextPath = IndexPath(item: (indexPath?.item)! + 1, section: (indexPath?.section)!)
        collectionView.scrollToItem(at: nextPath, at: .left, animated: true)
    }
    
    //MARK: 开始拖拽时,停止定时器
    internal func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        timer.fireDate = Date.distantFuture
    }
    
    //MARK: 结束拖拽时,恢复定时器
    internal func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        timer.fireDate = Date(timeIntervalSinceNow: 2.0)
    }
    
    //MARK: 监听手动减速完成(停止滚动)  - 获取当前页码,滚动到下一页,如果当前页码是第一页,继续往下滚动,如果是最后一页回到第一页
    internal func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let offsetX : CGFloat = scrollView.contentOffset.x
        let page : NSInteger = NSInteger(offsetX / bounds.size.width)
        let itemsCount = collectionView.numberOfItems(inSection: 0)
        if page == 0 { //第一页
            collectionView.contentOffset = CGPoint(x: offsetX + CGFloat((imageURLStringArr?.count)!) * CGFloat(KCount) * bounds.size.width, y: 0)
        } else if page == itemsCount - 1 { //最后一页
            collectionView.contentOffset = CGPoint(x: offsetX - CGFloat((imageURLStringArr?.count)!) * CGFloat(KCount) * bounds.size.width, y: 0)
        }
    }
    
    //MARK: 滚动动画结束的时候调用 - 获取当前页码,滚动到下一页,如果当前页码是第一页,继续往下滚动,如果是最后一页回到第一页
    internal func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        scrollViewDidEndDecelerating(collectionView)
    }
    
    //MARK: 正在滚动(设置分页) -- 算出滚动位置,更新指示器
    internal func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetX = scrollView.contentOffset.x
        var page = NSInteger(offsetX / bounds.size.width + 0.5)
        if imageURLStringArr?.count == 0{
            page = 0
        }else{
            page = page % (imageURLStringArr?.count)!
        }
        pageControl.currentPage = page
    }

    //MARK: 随父控件的消失取消定时器
    internal override func removeFromSuperview() {
        super.removeFromSuperview()
        timer.invalidate()
    }
}

//MARK: 数据源和代理方法
extension CycleView {
    //FIXME: 点击cell的代理方法
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if imageURLStringArr?.count == 0{
            return
        }else{
            delegate?.cycleViewDidSelectedItemAtIndex(indexPath.item % (imageURLStringArr?.count)!)
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (imageURLStringArr?.count ?? 0)! * 2 * KCount
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : CycleCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CycleCell
        cell.mode = mode
        if imageURLStringArr!.count > 0{
            cell.imageURLString = imageURLStringArr?[indexPath.item % (imageURLStringArr?.count)!] ?? ""
        }
        cell.imageView.bm.addConstraints([.top(self.contentInset.top), .left(self.contentInset.left), .right(self.contentInset.right), .bottom(self.contentInset.bottom)])
        cell.imageView.cornerRadius = CGFloat(self.imageCornerRedius)
        return cell
    }
}

//MARK: 设置UI--轮播界面,指示器,定时器
extension CycleView {
    fileprivate func initUI() {
        
        let layout : CellFlowLayout = CellFlowLayout()
        collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        collectionView.bounces = false
        collectionView.backgroundColor = .clear
        collectionView.isPagingEnabled = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self as UICollectionViewDataSource
        collectionView.delegate = self as UICollectionViewDelegate
        collectionView.register(CycleCell.self, forCellWithReuseIdentifier: "cell")
        addSubview(collectionView)
        
        let width : CGFloat = 120
        let height : CGFloat = 20
        let pointX : CGFloat = (self.w - width) * 0.5
        let pointY : CGFloat = bounds.size.height - height
        pageControl = UIPageControl(frame: CGRect(x: pointX, y: pointY, width: width, height: height))
        pageControl.isUserInteractionEnabled = false
        pageControl.pageIndicatorTintColor = UIColor.lightText
        pageControl.currentPageIndicatorTintColor = UIColor.white
        addSubview(pageControl)
        
        timer = Timer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        RunLoop.current.add(timer, forMode: .common)
        timer.fireDate = Date(timeIntervalSinceNow: 1.0)
    }
}


