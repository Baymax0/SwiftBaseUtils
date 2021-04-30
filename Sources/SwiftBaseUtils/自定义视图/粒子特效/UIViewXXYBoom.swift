//
//  UIView+XXYBang.swift
//  XXYBang~
//
//  Created by Xiaoxueyuan on 15/10/1.
//  Copyright (c) 2015年 Xiaoxueyuan. All rights reserved.
//

import UIKit
extension UIView{
    
    fileprivate struct AssociatedKeys {
        static var BoomCellsName = "XXYBoomCells"
        static var ScaleSnapshotName = "XXYBoomScaleSnapshot"
    }
    //MARK: - 私有方法
    fileprivate var boomCells:[CALayer]?{
        get{
            return objc_getAssociatedObject(self, &AssociatedKeys.BoomCellsName) as? [CALayer]
        }
        set{
            if let newValue = newValue{
                willChangeValue(forKey: AssociatedKeys.BoomCellsName)
                objc_setAssociatedObject(self, &AssociatedKeys.BoomCellsName, newValue as [CALayer], .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                didChangeValue(forKey: AssociatedKeys.BoomCellsName)
            }
        }
    }
    //截图
    fileprivate var scaleSnapshot:UIImage?{
        get{
            return objc_getAssociatedObject(self, &AssociatedKeys.ScaleSnapshotName) as? UIImage
        }
        set{
            if let newValue = newValue{
                willChangeValue(forKey: AssociatedKeys.ScaleSnapshotName)
                objc_setAssociatedObject(self, &AssociatedKeys.ScaleSnapshotName, newValue as UIImage, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                didChangeValue(forKey: AssociatedKeys.ScaleSnapshotName)
            }
        }
    }

    
    //粒子动画
    @objc fileprivate func cellAnimations(){
        for shape in boomCells!{
            shape.position = center
            shape.opacity = 1
            let during = TimeInterval(arc4random()%8) * 0.05 + 0.6
            //路径
            let moveAnimation = CAKeyframeAnimation(keyPath: "position")
            moveAnimation.path = makeRandomPath(shape).cgPath
            moveAnimation.isRemovedOnCompletion = false
            moveAnimation.fillMode = .forwards
//            moveAnimation.timingFunction = CAMediaTimingFunction(controlPoints: 0.240000, 0.590000, 0.506667, 0.026667)
            moveAnimation.timingFunction = CAMediaTimingFunction(controlPoints: 0.25, 0.1, 0.25, 1.0)
            moveAnimation.duration = during
            
            let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
            scaleAnimation.toValue = makeScaleValue()
            scaleAnimation.duration = during
            scaleAnimation.isRemovedOnCompletion = false
            scaleAnimation.fillMode = .forwards
            
            let opacityAnimation = CABasicAnimation(keyPath: "opacity")
            opacityAnimation.fromValue = 1
            opacityAnimation.toValue = 0
            opacityAnimation.duration = during
            //            opacityAnimation.delegate = self
            opacityAnimation.isRemovedOnCompletion = true
            opacityAnimation.fillMode = .forwards
            opacityAnimation.timingFunction = CAMediaTimingFunction(controlPoints: 0.380000, 0.033333, 0.963333, 0.260000)
            
            shape.opacity = 0
            shape.add(scaleAnimation, forKey: "scaleAnimation")
            shape.add(moveAnimation, forKey: "moveAnimation")
            shape.add(opacityAnimation, forKey: "opacityAnimation")
        }
    }
    
    //随机产生震动值
    fileprivate func makeShakeValue(_ p:CGFloat) -> CGFloat{
        let basicOrigin = -CGFloat(6)
        let maxOffset = -2 * basicOrigin
        return basicOrigin + maxOffset * (CGFloat(arc4random()%101)/CGFloat(100)) + p
    }
    
    //随机产生缩放数值
    fileprivate func makeScaleValue() -> CGFloat{
        return 1 - 0.7 * (CGFloat(arc4random() % 61)/CGFloat(50))
    }
    
    //随机产生粒子路径
    fileprivate func makeRandomPath(_ aLayer:CALayer) -> UIBezierPath{
        let particlePath = UIBezierPath()
        particlePath.move(to: layer.position)
        let basicLeft = -CGFloat(1.3 * layer.frame.size.width)
        let maxOffset = 2 * abs(basicLeft)
        let randomNumber = arc4random()%101
        let endPointX = basicLeft + maxOffset * (CGFloat(randomNumber)/CGFloat(100)) + aLayer.position.x
        let controlPointOffSetX = (endPointX - aLayer.position.x)/2  + aLayer.position.x
        let controlPointOffSetY = layer.position.y - 0.2 * layer.frame.size.height - CGFloat(arc4random() % UInt32(1.2 * layer.frame.size.height))
        let endPointY = layer.position.y + layer.frame.size.height/2 + CGFloat(arc4random() % UInt32(layer.frame.size.height/2))
        particlePath.addQuadCurve(to: CGPoint(x: endPointX, y: endPointY), controlPoint: CGPoint(x: controlPointOffSetX, y: controlPointOffSetY))
        return particlePath
    }
    
    fileprivate func colorWithPoint(_ x:Int,y:Int,image:UIImage) -> UIColor{
        let pixelData = image.cgImage?.dataProvider?.data
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        
        let pixelInfo: Int = ((Int(image.size.width) * y) + x) * 4
        
        let a = CGFloat(data[pixelInfo]) / CGFloat(255.0)
        let r = CGFloat(data[pixelInfo+1]) / CGFloat(255.0)
        let g = CGFloat(data[pixelInfo+2]) / CGFloat(255.0)
        let b = CGFloat(data[pixelInfo+3]) / CGFloat(255.0)
        
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
    
    //移除粒子
    func removeBoomCells(){
        if boomCells == nil {
            return
        }
        for item in boomCells!{
            item.removeFromSuperlayer()
        }
        boomCells?.removeAll(keepingCapacity: false)
        boomCells = nil
    }
    
    //MARK: - 公开方法
    //从layer获取View的截图
    func snapshot() -> UIImage{
        UIGraphicsBeginImageContext(layer.frame.size)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    func boom(){
        //摇摆~ 摇摆~ 震动~ 震动~
        var valX = [makeShakeValue(layer.position.x)]
        var valY = [makeShakeValue(layer.position.y)]
        for _ in 0..<15{
            valX.append(makeShakeValue(layer.position.x))
            valY.append(makeShakeValue(layer.position.y))
        }
        let shakeXAnimation = CAKeyframeAnimation(keyPath: "position.x")
        shakeXAnimation.duration = 0.5
        shakeXAnimation.values = valX
        let shakeYAnimation = CAKeyframeAnimation(keyPath: "position.y")
        shakeYAnimation.duration = shakeXAnimation.duration
        shakeYAnimation.values = valY
        
        
        layer.add(shakeXAnimation, forKey: "shakeXAnimation")
        layer.add(shakeYAnimation, forKey: "shakeYAnimation")
        
        //view的缩放和透明度动画 延后执行
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            //缩放
            let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
            scaleAnimation.toValue = 0.8
            scaleAnimation.duration = 0.3
            scaleAnimation.fillMode = .forwards
            
            //透明度
            let opacityAnimation = CABasicAnimation(keyPath: "opacity")
            opacityAnimation.fromValue = 1
            opacityAnimation.toValue = 0.1
            opacityAnimation.duration = 0.3
            opacityAnimation.fillMode = .forwards
            
            self.layer.add(scaleAnimation, forKey: "lscale")
            self.layer.add(opacityAnimation, forKey: "lopacity")
            self.layer.opacity = 0
        }
        
        if boomCells == nil{
            boomCells = [CALayer]()
            let cellSize:CGFloat = 5
            let cellNum_h = Int(frame.size.width / cellSize)
            let cellNum_V = Int(frame.size.height / cellSize)
            
            var x:CGFloat = 0
            var y:CGFloat = 0

            for i in 0...cellNum_h{
                for j in 0...cellNum_V{
                    if j == 0{
                        y = 0
                    }
                    if scaleSnapshot == nil{
                        scaleSnapshot = snapshot().scaleImageToSize(CGSize(width: cellNum_h*2, height: cellNum_V*2))
                    }
                    let color = scaleSnapshot!.getPixelColorAtLocation(CGPoint(x: CGFloat(i * 2), y: CGFloat(j * 2)))
                    let shape = CALayer()
                    shape.backgroundColor = color.cgColor
                    shape.opacity = 0
                    shape.cornerRadius = 0
                    shape.frame = CGRect(x: x, y: y, width: cellSize, height: cellSize)
                    layer.superlayer?.addSublayer(shape)
                    boomCells?.append(shape)
                    y = y + cellSize
                }
                x = x + cellSize
            }
        }
        // 延后执行
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.4) {
            self.cellAnimations()
        }
    }
    
    //重置状态
    func reset(){
        layer.opacity = 1
    }
    
    //MARK: - 生命周期相关，在从父View移除的时候释放粒子
//    open override class func initialize() {
//        class Static {
//            static let token: Int = 0
//        }
//
//        let originalSelector = #selector(UIView.willMove(toSuperview:))
//        let swizzledSelector = #selector(UIView.XXY_willMoveToSuperview(_:))
//
//        let originalMethod = class_getInstanceMethod(self, originalSelector)
//        let swizzledMethod = class_getInstanceMethod(self, swizzledSelector)
//
//        let didAddMethod = class_addMethod(self, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))
//
//        if didAddMethod {
//            class_replaceMethod(self, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
//        } else {
//            method_exchangeImplementations(originalMethod, swizzledMethod);
//        }
//    }
    
//    func XXY_willMoveToSuperview(_ newSuperView:UIView){
//        removeBoomCells()
//        XXY_willMoveToSuperview(newSuperView)
//    }
    
    
}
extension UIImage{
    
    fileprivate struct AssociatedKeys {
        static var aRGBBitmapContextName = "aRGBBitmapContext"
    }
    
    fileprivate var aRGBBitmapContext:CGContext?{
        get{
            return (objc_getAssociatedObject(self, &AssociatedKeys.aRGBBitmapContextName) as! CGContext?)
        }
        set{
            if let newValue = newValue{
                willChangeValue(forKey: AssociatedKeys.aRGBBitmapContextName)
                objc_setAssociatedObject(self, &AssociatedKeys.aRGBBitmapContextName, newValue as CGContext, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                didChangeValue(forKey: AssociatedKeys.aRGBBitmapContextName)
            }
        }
    }
    
    func createARGBBitmapContextFromImage() -> CGContext{
        if aRGBBitmapContext != nil{
            return aRGBBitmapContext!
        }else{
            let pixelsWidth = self.cgImage?.width
            let pixelsHeitht = self.cgImage?.height
            let bitmapBytesPerRow = pixelsWidth! * 4
            let bitmapByteCount = bitmapBytesPerRow * pixelsHeitht!
            let colorSpace = CGColorSpaceCreateDeviceRGB()
            let bitmapData = malloc(bitmapByteCount)
            let context = CGContext(data: bitmapData,width: pixelsWidth!,height: pixelsHeitht!,bitsPerComponent: 8,bytesPerRow: bitmapBytesPerRow,space: colorSpace, bitmapInfo: CGBitmapInfo().rawValue | CGImageAlphaInfo.premultipliedFirst.rawValue)!
            aRGBBitmapContext = context
            return context
        }
    }
    
    func getPixelColorAtLocation(_ point:CGPoint) -> UIColor{
        let pixelData=self.cgImage!.dataProvider!.data
        let data:UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        let pixelInfo: Int = ((Int(self.size.width) * Int(point.y)) + Int(point.x)) * 4
        
        let b = CGFloat(data[pixelInfo]) / CGFloat(255.0)
        let g = CGFloat(data[pixelInfo+1]) / CGFloat(255.0)
        let r = CGFloat(data[pixelInfo+2]) / CGFloat(255.0)
        let a = CGFloat(data[pixelInfo+3]) / CGFloat(255.0)
        
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
    
    
    //缩放图片
    func scaleImageToSize(_ size:CGSize) -> UIImage{
        UIGraphicsBeginImageContext(size)
        draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let res = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return res!
    }
    
}
