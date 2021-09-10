//
//  BMImagePreviewCell.swift
//  BaseUtilsDemo
//
//  Created by 宇树科技 on 2021/9/9.
//  Copyright © 2021 yimi. All rights reserved.
//

import Foundation

class BMImagePreviewCell: UICollectionViewCell {
    
    var singleTapBlock: ( () -> Void )?
    var longPressBlock: ( () -> Void )?
    var contentSCScrolled: ( (BMImagePreviewCell,CGFloat,Bool) -> Void )?
    
    var currentImage: UIImage? { return self.imageView.image }
    
    static let defaultMaxZoomScale: CGFloat = 3
    var scrollView: UIScrollView!
    var containerView: UIView!
    var imageView: UIImageView!
    
    var isDraging:Bool = false
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    override init(frame: CGRect) {
        super.init(frame: frame)
        print("init cell")
        setupUI()
    }
    
    func setupUI() {
        if self.scrollView == nil{
            self.scrollView = UIScrollView()
            self.scrollView.maximumZoomScale = BMImagePreviewCell.defaultMaxZoomScale
            self.scrollView.minimumZoomScale = 1
            self.scrollView.isMultipleTouchEnabled = true
            self.scrollView.delegate = self
            self.scrollView.showsHorizontalScrollIndicator = false
            self.scrollView.showsVerticalScrollIndicator = false
            self.scrollView.delaysContentTouches = false
            self.scrollView.alwaysBounceVertical = true
            self.scrollView.bm.add(toView: self, withConstraints: [.fill])
            if #available(iOS 11.0, *) {
                self.scrollView.contentInsetAdjustmentBehavior = .never
            }else{}
            self.containerView = UIView()
            self.scrollView.addSubview(self.containerView)
            
            self.imageView = UIImageView()
            self.imageView.contentMode = .scaleAspectFill
            self.imageView.clipsToBounds = true
            self.containerView.addSubview(self.imageView)
            
            let singleTap = UITapGestureRecognizer(target: self, action: #selector(singleTapAction(_:)))
            self.addGestureRecognizer(singleTap)
            
            let longGes = UILongPressGestureRecognizer(target: self, action: #selector(longPressAction(_:)))
            longGes.minimumPressDuration = 0.5
            self.addGestureRecognizer(longGes)
            
            let doubleTap = UITapGestureRecognizer(target: self, action: #selector(doubleTapAction(_:)))
            doubleTap.numberOfTapsRequired = 2
            self.addGestureRecognizer(doubleTap)
            singleTap.require(toFail: doubleTap)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.scrollView.zoomScale = 1
        self.resetSubViewSize()
    }
    
    func resetSubViewSize() {
        let size: CGSize = self.imageView.image?.size ?? self.bounds.size
        var frame: CGRect = .zero
        let viewW = self.bounds.width
        let viewH = self.bounds.height
        var width = viewW
        if UIApplication.shared.statusBarOrientation.isLandscape {
            let height = viewH
            frame.size.height = height
            let imageWHRatio = size.width / size.height
            let viewWHRatio = viewW / viewH
            if imageWHRatio > viewWHRatio {
                frame.size.width = floor(height * imageWHRatio)
                if frame.size.width > viewW {
                    // 宽图
                    frame.size.width = viewW
                    frame.size.height = viewW / imageWHRatio
                }
            } else {
                width = floor(height * imageWHRatio)
                if width < 1 || width.isNaN {
                    width = viewW
                }
                frame.size.width = width
            }
        } else {
            frame.size.width = width
            let imageHWRatio = size.height / size.width
            let viewHWRatio = viewH / viewW
            if imageHWRatio > viewHWRatio {
                // 长图
                frame.size.width = min(size.width, viewW)
                frame.size.height = floor(frame.size.width * imageHWRatio)
            } else {
                var height = floor(frame.size.width * imageHWRatio)
                if height < 1 || height.isNaN {
                    height = viewH
                }
                frame.size.height = height
            }
        }
        
        // 优化 scroll view zoom scale
        if frame.width < frame.height {
            self.scrollView.maximumZoomScale = max(BMImagePreviewCell.defaultMaxZoomScale, viewW / frame.width)
        } else {
            self.scrollView.maximumZoomScale = max(BMImagePreviewCell.defaultMaxZoomScale, viewH / frame.height)
        }
        
        self.containerView.frame = frame
        
        var contenSize: CGSize = .zero
        if UIApplication.shared.statusBarOrientation.isLandscape {
            contenSize = CGSize(width: width, height: max(viewH, frame.height))
            if frame.height < viewH {
                self.containerView.center = CGPoint(x: viewW / 2, y: viewH / 2)
            } else {
                self.containerView.frame = CGRect(origin: CGPoint(x: (viewW-frame.width)/2, y: 0), size: frame.size)
            }
        } else {
            contenSize = frame.size
            if frame.height < viewH {
                self.containerView.center = CGPoint(x: viewW / 2, y: viewH / 2)
            } else {
                self.containerView.frame = CGRect(origin: CGPoint(x: (viewW-frame.width)/2, y: 0), size: frame.size)
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            self.scrollView.contentSize = contenSize
            self.imageView.frame = self.containerView.bounds
            self.scrollView.contentOffset = .zero
        }
    }
    
    //MARK: ------------ Action ------------
    @objc func singleTapAction(_ tap: UITapGestureRecognizer) {
        self.singleTapBlock?()
    }
    // 长按
    @objc func longPressAction(_ ges: UILongPressGestureRecognizer) {
        guard let _ = self.currentImage else { return }
        if ges.state == .began {
            self.longPressBlock?()
        }
    }
    
    @objc func doubleTapAction(_ tap: UITapGestureRecognizer) {
        let scale: CGFloat = self.scrollView.zoomScale != self.scrollView.maximumZoomScale ? self.scrollView.maximumZoomScale : 1
        let tapPoint = tap.location(in: self)
        var rect = CGRect.zero
        rect.size.width = self.scrollView.frame.width / scale
        rect.size.height = self.scrollView.frame.height / scale
        rect.origin.x = tapPoint.x - (rect.size.width / 2)
        rect.origin.y = tapPoint.y - (rect.size.height / 2)
        self.scrollView.zoom(to: rect, animated: true)
    }
}

extension BMImagePreviewCell: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.containerView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let offsetX = (scrollView.frame.width > scrollView.contentSize.width) ? (scrollView.frame.width - scrollView.contentSize.width) * 0.5 : 0
        let offsetY = (scrollView.frame.height > scrollView.contentSize.height) ? (scrollView.frame.height - scrollView.contentSize.height) * 0.5 : 0
        self.containerView.center = CGPoint(x: scrollView.contentSize.width * 0.5 + offsetX, y: scrollView.contentSize.height * 0.5 + offsetY)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView.zoomScale == 1 else{ return }
        guard isDraging == true else{ return }
        if let block = contentSCScrolled{
            block(self,scrollView.contentOffset.y,false)
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard scrollView.zoomScale == 1 else{ return }
        isDraging = false
        if let block = contentSCScrolled{
            block(self,scrollView.contentOffset.y,true)
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isDraging = true
    }
    
}
