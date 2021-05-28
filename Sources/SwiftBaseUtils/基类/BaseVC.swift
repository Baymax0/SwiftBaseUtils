//
//  BaseVC.swift
//  wangfuAgent
//
//  Created by YiMi on 2018/7/11.
//  Copyright © 2018 lizhiwei. All rights reserved.
//


import IQKeyboardManagerSwift

// 页面离开的方式
enum BMVCDismissType {
    case pop    //返回上一级 页面注销
    case push   //跳转新页面
    case none   //空
}

class BaseVC: UIViewController {
    
    // MARK:  ----------- UI样式 -----------
    /// 隐藏导航栏下面的黑线
    var hideNavBottonLine:Bool!
    /// 隐藏导航栏
    var hideNav = false
    /// 是否可以侧划返回
    var popGestureEnable = true
    /// 状态栏颜色  需要指定的  重写该属性
    override var preferredStatusBarStyle: UIStatusBarStyle{
        get{ return  .default }}
    /// 是否自动适配键盘与输入框位置
    var autoHideKeyboard:Bool = true
    
    /// 全局navi内容主题色（默认nil，与系统默认保持一致）
    static var global_navTintColor:UIColor! = nil
    /// 全局navi背景色（默认nil，与系统默认保持一致）
    static var global_navBarTintColor:UIColor! = nil
    
    /// 当前页面 navi 内容主题色
    var barContenColor:UIColor! = BaseVC.global_navTintColor
    /// 当前页面 navi 背景色
    var barBGColor:UIColor! = BaseVC.global_navBarTintColor
    
    
    // MARK:  ----------- 功能View -----------
    // 遮照背景视图
    var maskView = UIView()
    // 弹出框使用的 灰色背景遮照
    var blurMask: UIButton = {
        let btn = UIButton(frame: .init(x: 0, y: 0, width: KScreenWidth, height: KScreenHeight))
        btn.backgroundColor = UIColor.maskView
        return btn
    }()

    var window:UIWindow! {
        return UIApplication.shared.windows.filter{$0.isKeyWindow}.first
    }
    
    
    // MARK:  ----------- 变量存储 -----------
    /// viewwillappear 调用次数
    var appearTimes:Int = 0
    /// BaseVC.currentVC 或的当前展示的页面，判断用
    static var currentVC_Str:String?
    /// 当前的VC，全局可通过BaseVC.currentVC拿到，跳转用
    static var currentVC:BaseVC?
    
    /// 页面离开的方式
    var dismissType:BMVCDismissType = .none
    
    /// 页面传参回调
    var backClosure: ((Dictionary<String, Any>) -> ())?
    func setBackClosure(_ closure : @escaping (Dictionary<String, Any>) -> ()){ backClosure = closure}
    
    /// 记录上次请求的时间戳
    var lastLoadTime:Date = Date(timeIntervalSince1970: 0)
    var reloadIntervalTime:Double = 600
    /// 判断距离上次请求的时间 决定是否刷新
    var needLoadWhenAppear:Bool{
        return Date().timeIntervalSince(lastLoadTime) > (reloadIntervalTime)}
    
    /// 上次动画时间，用于cell列表刷新等 有先后顺序的动画
    private var lastCellDisplayTimeInterval: TimeInterval = Date.timeIntervalSinceReferenceDate
    
    //MARK: ----------- vc生命周期 -----------
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isTranslucent = false
        
        edgesForExtendedLayout = .all
        extendedLayoutIncludesOpaqueBars = YES
        
        self.initUI()
    }
    
    func initUI() {}

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 这里设置backgroundColor 会导致子类的xib中设置的背景色失效
//        self.view.backgroundColor = .white
        appearTimes = appearTimes + 1
        BaseVC.currentVC_Str = String(describing: self.classForCoder)
        BaseVC.currentVC = self
        
        navigationController?.setNavigationBarHidden(hideNav, animated: true)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = popGestureEnable
        
        if !hideNav {
            navigationController?.navigationBar.barTintColor = barBGColor
            if let _ = barContenColor {//设置中间文字大小和颜色
                navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : barContenColor!,
                                                                           NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18)]
            }
        }
        
        IQKeyboardManager.shared.shouldResignOnTouchOutside = self.autoHideKeyboard
        
        if let b = self.hideNavBottonLine, b == true{
            self.findHairlineImageViewUnder(sView: self.navigationController?.navigationBar)?.isHidden = true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let b = self.hideNavBottonLine, b == true{
            self.findHairlineImageViewUnder(sView: self.navigationController?.navigationBar)?.isHidden = false
        }
    }
    
    
    //MARK: ----------- Action -----------
    
    /// 返回事件
    @objc func back() {
        self.dismissType = .pop
        if let _ = self.navigationController {
            self.pop()
        }else{
            self.dismiss(animated: true, completion: nil)
        }
    }

    func addTapCloseKeyBoard(_ view:UIView) {
        let tag = UITapGestureRecognizer(target: self, action: #selector(closeKeyboard))
        view.addGestureRecognizer(tag)
    }
    
    @objc func closeKeyboard() {
        self.view.endEditing(true)
    }
    
    //MARK: ----------- Utils -----------
    
    /// 忽略自适应内边距
    func ignoreAutoAdjustScrollViewInsets(_ sc:UIScrollView?) {
        if #available(iOS 11.0, *) {
            sc?.contentInsetAdjustmentBehavior = .never
        }else{
            self.automaticallyAdjustsScrollViewInsets = NO
        }
    }
    
    func findHairlineImageViewUnder(sView: UIView?) -> UIImageView?{
        if sView == nil{
            return nil
        }
        if sView! is UIImageView && sView!.bounds.height <= 1 {
            return sView as? UIImageView
        }
        for sview in sView!.subviews {
            let imgs = self.findHairlineImageViewUnder(sView: sview)
            if imgs != nil && imgs!.bounds.height <= 1 {
                return imgs
            }
        }
        return nil
    }
    
    /// 自动判断运行延迟时间, 执行work
    /// interval:间隔时间
    func linerAnimation(interval:TimeInterval=0.06, work: @escaping() -> Void) {
        let now = Date.timeIntervalSinceReferenceDate
        // 计算延迟时间，距离前一次执行动画
        var delay = interval
        delay = max(0, delay - (now - lastCellDisplayTimeInterval))
        if delay == 0 {
            work()
        } else {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .milliseconds(Int(delay*1000))) {
                work()
            }
        }
        lastCellDisplayTimeInterval = now + delay
    }
}


// MARK:  提示框
extension BaseVC {
    func showMask(){
        if maskView.superview == nil{
            self.window.addSubview(maskView)
            maskView.bm.addConstraints([.fill])
        }
    }
    
    /// 居中显示View
    func showMaskWithViewInCenter(_ content:UIView){
        maskView.removeFromSuperview()
        self.window.addSubview(maskView)
        maskView.bm.addConstraints([.fill])

        blurMask.removeFromSuperview()
        maskView.addSubview(blurMask)
        blurMask.bm.addConstraints([.fill])

        blurMask.tag = 0
        blurMask.addTarget(self, action: #selector(hideMaskView), for: .touchUpInside)

        content.removeFromSuperview()
        maskView.addSubview(content)//把view的宽高布局转为约束
        content.bm.addConstraints([.w(content.w), .h(content.h), .center])
        
        //animation
        blurMask.alpha = 0;
        content.alpha = 0.5 //透明度渐变不带弹性
        UIView.animate(withDuration: 0.2, animations: {
            content.alpha = 1
            self.blurMask.alpha = 1
        })
        
        content.transform = CGAffineTransform.init(scaleX: 0.5, y: 0.5) //缩放带弹性
        UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 5, options: .curveEaseInOut, animations: {
            content.transform = CGAffineTransform.identity
        }) { (_) in}
    }
    
    /// 居下显示View
    func showMaskWithViewAtBottom(_ content:UIView){
        maskView.removeFromSuperview()
        self.window.addSubview(maskView)
        maskView.bm.addConstraints([.fill])

        blurMask.removeFromSuperview()
        maskView.addSubview(blurMask)
        blurMask.bm.addConstraints([.fill])
        
        blurMask.tag = 1;
        blurMask.addTarget(self, action: #selector(hideMaskView), for: .touchUpInside)

        content.removeFromSuperview()
        maskView.addSubview(content)//把view的宽高布局转为约束
        content.bm.addConstraints([.w(content.w), .h(content.h), .center_X(0), .bottom(40)])
        
        //animation
        blurMask.alpha = 0;
        content.alpha = 0.5 //透明度渐变不带弹性
        UIView.animate(withDuration: 0.2, animations: {
            content.alpha = 1
            self.blurMask.alpha = 1
        })
        
        content.transform = CGAffineTransform.init(translationX: 0, y: 100) //缩放带弹性
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 5, options: .curveEaseInOut, animations: {
            content.transform = CGAffineTransform.identity
        }) { (_) in}
    }
    
    /// 居下显示View
    func showMaskWithViewAtBottom_full(_ content:UIView){
        maskView.removeFromSuperview()
        self.window.addSubview(maskView)
        maskView.bm.addConstraints([.fill])

        blurMask.removeFromSuperview()
        maskView.addSubview(blurMask)
        blurMask.bm.addConstraints([.fill])
        
        blurMask.tag = 1;
        blurMask.addTarget(self, action: #selector(hideMaskView), for: .touchUpInside)

        content.removeFromSuperview()
        maskView.addSubview(content)//把view的宽高布局转为约束
        content.bm.addConstraints([.w(content.w), .h(content.h), .center_X(0), .bottom(0)])
        
        //animation
        blurMask.alpha = 0;
        content.alpha = 0.5 //透明度渐变不带弹性
        UIView.animate(withDuration: 0.2, animations: {
            content.alpha = 1
            self.blurMask.alpha = 1
        })
        
        content.transform = CGAffineTransform.init(translationX: 0, y: 70) //缩放带弹性
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.65, initialSpringVelocity: 5, options: .curveEaseInOut, animations: {
            content.transform = CGAffineTransform.identity
        }) { (_) in}
    }
    
    /// 自定义位置显示View
    func showMaskWithView(_ content:UIView, from:CGRect,to:CGRect){
        maskView.removeFromSuperview()
        self.window.addSubview(maskView)
        maskView.bm.addConstraints([.fill])

        blurMask.removeFromSuperview()
        maskView.addSubview(blurMask)
        blurMask.bm.addConstraints([.fill])
        
        blurMask.tag = 1;
        blurMask.addTarget(self, action: #selector(hideMaskView), for: .touchUpInside)

        content.removeFromSuperview()
        maskView.addSubview(content)//把view的宽高布局转为约束
        content.frame = from
        
        //animation
        blurMask.alpha = 0;
        content.alpha = 0.5 //透明度渐变不带弹性
        UIView.animate(withDuration: 0.2, animations: {
            content.alpha = 1
            self.blurMask.alpha = 1
        })
        
//        content.transform = CGAffineTransform.init(translationX: 0, y: 50) //缩放带弹性
        UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 5, options: .curveEaseInOut, animations: {
            content.frame = to
        }) { (_) in}
    }
    
    /// 隐藏
    @objc func hideMaskView() -> Void {
        let views = maskView.subviews
        let content = views.last//提示框
        
        UIView.animate(withDuration: 0.3) {
            self.blurMask.alpha = 0
        } completion: { (_) in
            self.maskView.removeFromSuperview()
        }

        UIView.animate(withDuration: 0.15, animations: {
            content?.alpha = 0
            if self.blurMask.tag == 1{
                content?.transform = CGAffineTransform.init(translationX: 0, y: 80)
            }else{
                content?.transform = CGAffineTransform.init(scaleX: 0.5, y: 0.5)
            }
        }) { (_) in
            content?.removeFromSuperview()
            content?.transform = CGAffineTransform.identity
        }
    }
}


// MARK:  页面导航
extension BaseVC {
    class func fromStoryboard(_ identify: String? = nil) -> BaseVC {
        let id = identify ?? String(describing: type(of:self.init()))
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: id) as! BaseVC
        vc.modalPresentationStyle = .fullScreen
        return vc
    }
    
    func pushViewController(_ vc:UIViewController, _ animation:Bool = true) {
        self.dismissType = .push
        if let n = self.navigationController{
            n.pushViewController(vc, animated: animation)
        }else{
            self.present(vc, animated: animation, completion: nil)
        }
    }
    
    func pushViewControllerWithHero(_ vc:BaseVC) {
        self.dismissType = .push
        if let n = self.navigationController{
            n.hero.isEnabled = true
            n.pushViewController(vc, animated: true)
            vc.hero.isEnabled = true
        }
    }
    
    func pop(_ animation:Bool = true) -> Void{
        self.dismissType = .pop
        if let n = self.navigationController{
            n.popViewController(animated: animation)
        }else{
            self.dismiss(animated: animation, completion: nil)
        }
    }
    
    /// -1 = 前一个，
    func pop(index:Int) -> Void{
        if let arr = self.navigationController?.children {
            let newIndex = arr.count - 1 + index
            let vc = arr[newIndex]
            self.navigationController?.popToViewController(vc, animated: YES)
            self.dismissType = .pop
        }
    }
}


// MARK:  自定义UI Create方法
extension UIViewController {
    func barItem(_ target:(Any), title:String, imgName:String?, action:Selector , color:UIColor = #colorLiteral(red: 0.2588235294, green: 0.2588235294, blue: 0.2588235294, alpha: 1)) -> UIBarButtonItem {
        let btn = self.barBtn(target, title: title, imgName: imgName, action: action, color: color)
        let item = UIBarButtonItem(customView: btn)
        return item
    }
    
    func barBtn(_ target:(Any), title:String, imgName:String?, action:Selector , color:UIColor = #colorLiteral(red: 0.2588235294, green: 0.2588235294, blue: 0.2588235294, alpha: 1)) -> UIButton {
        let btn = UIButton(type: .custom)
        btn.tintColor = color
        btn.addTarget(target, action: action, for: .touchUpInside)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        var margin = 10
        if #available(iOS 10.0, *) {
            margin = 2
        }
        var w = 18 * title.count + margin
        w = w > 30 ? w : 30
        
        btn.frame = CGRect(x: 0, y: 0, width: w, height: 44)
        if imgName != nil {
            let img = UIImage(named:imgName!)?.withRenderingMode(.alwaysTemplate)
            btn.setImage(img, for: .normal)
        }
        btn.setTitle(title, for: .normal)
        btn.setTitleColor(color, for: .normal)
        return btn
    }
}

