//
//  BaseVC.swift
//  wangfuAgent
//
//  Created by YiMi on 2018/7/11.
//  Copyright © 2018 lizhiwei. All rights reserved.
//


import IQKeyboardManagerSwift

protocol CustomBottomAlertViewDelagate{
    func willAppear()
    func didAppear()
    func willDisappear()
}

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
    
    // MARK:  ----------- 功能View ----------
    var window:UIWindow! {
        return UIApplication.shared.windows.filter{$0.isKeyWindow}.first
    }
    
    // MARK:  ----------- 变量存储 -----------
    /// viewwillappear 调用次数
    var appearTimes:Int = 0
    /// BaseVC.currentVC 或的当前展示的页面，判断用
    static var currentVC_Str:String?
    /// 当前的VC，全局可通过BaseVC.currentVC拿到，跳转用
    weak static var currentVC:BaseVC?
    
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
    var lastCellDisplayTimeInterval: TimeInterval = Date.timeIntervalSinceReferenceDate
    
    // MARK:  ----------- 加载动画 -----------
    var indicatorView :BMIndicatorView!
    
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
    
    //MARK: ------------ BaseVC+CustomAlert ------------
    // 遮照背景视图
    var maskView: UIView!
    // 弹出框内容试图
    var alertContentBtn: UIButton!
    var alertContentBtnBottom:NSLayoutConstraint!
    var alertBottomView:CustomBottomAlertViewDelagate?
    var isMaskViewShowed:Bool{
        if maskView == nil { return false }
        if maskView.superview == nil { return false }
        return true
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

