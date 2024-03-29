//
//  ScanVC.swift
//  wangfu2
//
//  Created by yimi on 2018/11/13.
//  Copyright © 2018 zbkj. All rights reserved.
//


import AVFoundation

class ScanVC: BaseVC {
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        get{ return .lightContent }
    }
    
    var holeH = KScreenWidth * 0.7
    var scanHoleY: CGFloat {
        return (KScreenHeight - holeH)*0.4
    }
    var holeRect:CGRect{
        return CGRect(x: KScreenWidth * 0.15, y: scanHoleY, width: holeH, height: holeH)
    }
    
    var naviView:UIView = {
        let v = UIView(frame: CGRect(x: 0, y: 0, width: KScreenWidth, height: KNaviBarH))
        v.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.6044234155)
        
        let btn = UIButton(frame: CGRect(x: 0, y: KNaviBarH-44, width: 60, height: 44))
        let img = UIImage(named: "BMback_Icon")?.withRenderingMode(.alwaysTemplate)
        btn.setImage(img, for: .normal)
        btn.tag = 99
        btn.tintColor = .white
        btn.addTarget(self, action: #selector(back), for: .touchUpInside)
        v.addSubview(btn)
        btn.bm.addConstraints([.left(0), .bottom(0), .w(60), .h(44)])
        return v
    }()
    
    var scanView:UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: KScreenWidth, height: KScreenHeight))
        view.backgroundColor = .black
        return view
    }()
    
    var lightBtn:UIButton = {
        let btn = UIButton(frame: CGRect(x: KScreenWidth-60, y: KNaviBarH-44, width: 60, height: 44))
        let img = UIImage(named: "scan-dark")?.withRenderingMode(.alwaysTemplate)
        btn.setImage(img, for: .normal)
        btn.imageView?.contentMode = .scaleAspectFit
        btn.tintColor = .white
        btn.addTarget(self, action: #selector(openLight), for: .touchUpInside)

        return btn
    }()

    //扫码核心
    var captureSession:AVCaptureSession?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var previewLayer:AVCaptureVideoPreviewLayer?
    var timer:Timer?
    var getResult:Bool = false

    //扫码遮挡试图
    var blackView:UIView = {
        let v = UIView(frame: CGRect(x: 0, y: 0, width: KScreenWidth, height: KScreenHeight))
        v.backgroundColor = UIColor.maskView
        return v
    }()
    var slideBGView :UIImageView = {
        let v = UIImageView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        v.image = UIImage(named: "scan-slider-bg")
        v.clipsToBounds = true
        return v
    }()
    var sliderView :UIImageView = {
        let v = UIImageView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        v.image = UIImage(named: "scan-slider")
        return v
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideNav = true
        self.view.backgroundColor = .black
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startScaning()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.endScaning()
    }
    
    override func initUI() {
        self.view.addSubview(scanView)
        
        let bezierPath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: KScreenWidth, height: KScreenHeight), cornerRadius: 0)
        bezierPath.append(UIBezierPath(roundedRect: holeRect, cornerRadius: 0).reversing())
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = bezierPath.cgPath
        blackView.layer.mask = shapeLayer
        self.view.addSubview(blackView)
        
        slideBGView.frame = holeRect
        self.view.addSubview(slideBGView)
        
        sliderView.frame = CGRect(x: 0, y: -30, width: holeH, height: 30)
        slideBGView.addSubview(sliderView)
        
        self.view.addSubview(naviView)
        naviView.addSubview(lightBtn)
        lightBtn.bm.addConstraints([.right(0), .bottom(0), .w(60), .h(44)])
    }
    
    @objc func timeRepateAction(){
        sliderView.frame = CGRect(x: 0, y: -30, width: holeH, height: 30)
        UIView.animate(withDuration: 2-0.1) {
            self.sliderView.frame = CGRect(x: 0, y: self.holeH, width: self.holeH, height: 30)
        }
    }
    
    //返回
    @objc override func back(){
        pop()
    }
    
    // 打开或关闭闪光灯
    @objc func openLight(){
        if lightBtn.isSelected{
            //关闭 闪光灯
            if let device = AVCaptureDevice.default(for: .video), device.hasTorch{
                do{
                    try device.lockForConfiguration()
                    device.torchMode = .off
                    device.unlockForConfiguration()
                }catch{ return }
            }
            lightBtn.isSelected = false
        }else{
            if let device = AVCaptureDevice.default(for: .video), device.hasTorch{
                do{
                    try device.lockForConfiguration()
                    device.torchMode = .on
                    device.unlockForConfiguration()
                }catch{
                    bm_print(error)
                    Hud.showText("闪光灯无法打开")
                    return
                }
            }else{
                Hud.showText("当前设备识别不到闪光灯")
                return
            }
            lightBtn.isSelected = true
        }
    }
    
    //开启摄像头
    func startScaning(){
        if let device = AVCaptureDevice.default(for: .video){
            do {
                let input = try AVCaptureDeviceInput(device: device)
                captureSession = AVCaptureSession()
                captureSession?.addInput(input)
            }catch{
//                WFPermissionType.capture.showAlert()
                return
            }
            let output = AVCaptureMetadataOutput()
            captureSession?.addOutput(output)
            output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            output.metadataObjectTypes = [.qr,.ean13,.code128]
            
            previewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
            previewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            previewLayer?.frame = view.layer.bounds
            scanView.layer.addSublayer(previewLayer!)
            captureSession?.startRunning()
            
            timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(timeRepateAction), userInfo: nil, repeats: true)
            timeRepateAction()
            
            getResult = false
        }
    }
    
    //关闭摄像头
    func endScaning(){
        captureSession?.stopRunning()
        captureSession = nil
        timer?.invalidate()
        timer = nil
    }
    
    // 拿到扫描内容 重写
    func receiveScanCode(_ code:String?){
        bm_print(code ?? "")
    }
}

extension ScanVC:AVCaptureMetadataOutputObjectsDelegate{
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if getResult == true{
            return
        }
        
        getResult = true
        self.endScaning()
        
        // 取出第一个metadata
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        if metadataObj.type == .qr || metadataObj.type == .ean13 || metadataObj.type == .code128 {
            if metadataObj.stringValue != nil {
                self.receiveScanCode(metadataObj.stringValue)
            }
        }else{
            Hud.showText("二维码识别异常，请重新扫描")
            Hud.runAfterHud {
                self.getResult = false
            }
        }
    }
}

