//
//  BaseTableVC.swift
//  wangfuAgent
//
//  Created by lzw on 2018/7/11.
//  Copyright © 2018 zhuanbangTec. All rights reserved.
//



class ListModel: HandyJSON {
    required init() {}
}
@objc public protocol MyTableViewGestureDelegate {
    func myTableViewGestureRecognizer() -> Bool
}
class MyTableView: UITableView ,UIGestureRecognizerDelegate{
    ///不想让手势透传可以用代理
    weak var gestureDelegate: MyTableViewGestureDelegate?
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if let delegate = gestureDelegate{
            return delegate.myTableViewGestureRecognizer()
        }
        return YES
    }
}

class BaseTableVC<T:HandyJSON>: BaseVC {
    
    // 列表请求接口 最后一次的 code值
    var listRequestCode = 1
    
    var tableview: MyTableView?
    var pageNo = 1
    var PageSize = KPageSize
    var dataArr:[T] = []
    var param = Dictionary<String,Any>()
    
    var footNoDataText:String = ""
    
    // cell显示的时候是否显示加载动画
    var needOpenCellShowAnimation:Bool = false
    
    // 请求失败是否提示错误
    var showRequestError:Bool = false
    // 是否缓存 有值就缓存 没有就不缓存
    var listCacheKey:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableview?.isScrollEnabled = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tableview?.isScrollEnabled = false
    }
    
    func initTableView(rect:CGRect! ,_ style:UITableView.Style = .plain) -> Void {
        if rect == nil{
            tableview = MyTableView.init(frame: .zero, style: style)
            indicatorView = BMIndicatorView.showInView(view)
            indicatorView.bm.addConstraints([.fill])
        }else{
            tableview = MyTableView.init(frame: rect, style: style)
            indicatorView = BMIndicatorView.showInView(view)
            indicatorView.frame = rect
        }
        tableview?.separatorStyle = .none
        tableview?.backgroundColor = .white
        
        tableview?.keyboardDismissMode = .onDrag//滚动退出键盘
        
        tableview?.estimatedRowHeight = 0
        tableview?.estimatedSectionHeaderHeight = 0
        tableview?.estimatedSectionFooterHeight = 0
        view.addSubview(tableview!)
        ignoreAutoAdjustScrollViewInsets(tableview)
        
    }
    
    func initMJHeadView() -> Void {
        let header = MJRefreshNormalHeader()
        header.setRefreshingTarget(self, refreshingAction: #selector(BaseTableVC.loadNewData))
        header.lastUpdatedTimeLabel?.isHidden = YES
        header.stateLabel?.isHidden = YES
        tableview?.mj_header = header
        
        let foot = MJRefreshAutoNormalFooter()
        foot.setRefreshingTarget(self, refreshingAction: #selector(BaseTableVC.loadMoreData))
        foot.triggerAutomaticallyRefreshPercent = -9
        foot.stateLabel?.textColor = .KTextLightGray
        foot.setTitle("", for: .idle)
        foot.setTitle(footNoDataText, for: .noMoreData)
        tableview?.mj_footer = foot
    }
    
    func loadNewDataWithIndicator() -> Void {
        showLoadingView()
        loadNewData()
    }
    
    @objc func loadNewData() -> Void {
        //记录刷新时间
        lastLoadTime = Date()
        tableview?.mj_footer?.resetNoMoreData()
        loadData(1)
    }
    
    @objc func loadMoreData() -> Void {
        if tableview?.mj_footer != nil && tableview?.mj_footer?.state != .noMoreData{
            loadData(pageNo+1)
        }
    }
    
    //请求数据  重写 请求数据
    func loadData(_ page:Int) -> Void {
        return
    }
    
    @discardableResult
    func getList(key: BMApiTemplete<Array<T>?>, page:Int, finished:@escaping ()->()) -> DataRequest{
        param["pageNumber"] = page
        let count = self.dataArr.count
        return network[key].request(params: param) { (resp) in
            self.listRequestCode = resp!.code
            if resp?.code == 1{
                self.pageNo = page

                let temp = resp!.data ?? []
                if page == 1{
                    self.dataArr = temp
                }else{
                    self.dataArr.append(contentsOf: temp)
                }
            }else if resp!.code < 0 && page == 1{
                self.dataArr = []
            }else{
                if self.showRequestError == false{
                    Hud.showText(resp?.msg ?? "")
                }
            }
            
            if resp?.code != -999{
                self.finishLoadDate(resp!.code)
                //已经有数据时的 下拉刷新 关闭渐变显示
                if count == 0 && self.dataArr.count != 0 && page == 1{
                    self.needOpenCellShowAnimation = true
                }else{
                    self.needOpenCellShowAnimation = false
                }
                
                finished()
                self.reloadData(resp!.code)
            }
        }
    }
    
    func finishLoadDate(_ code:Int) -> Void {
        if tableview?.mj_header != nil {
            tableview?.mj_header?.endRefreshing()
            if code == -1 || dataArr.count % PageSize != 0{
                tableview?.mj_footer?.endRefreshingWithNoMoreData()
            }else{
                tableview?.mj_footer?.endRefreshing()
            }
            
            if dataArr.count == 0{
                tableview?.mj_footer?.endRefreshingWithNoMoreData()
            }
        }
    }
    
    func showLoadingView() -> Void {
        tableview?.isHidden = true
        indicatorView.showWait()
    }
    
    //刷新数据
    func reloadData(_ code:Int = 1) -> Void {
        if dataArr.count == 0 && code == -1{
            indicatorView.showNoData()
        }else{
            indicatorView.hide()
            tableview?.isHidden = false
        }
        tableview?.reloadData()
        
    }
}



