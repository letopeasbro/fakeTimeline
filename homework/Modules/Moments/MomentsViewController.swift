//
//  MomentsViewController.swift
//  homework
//
//  Created by 刘奕成 on 2019/6/13.
//  Copyright © 2019 Eason. All rights reserved.
//

import UIKit
import MJRefresh

class MomentsViewController: UIViewController {
    
    private let topView = MomentsTopView(frame: CGRect(x: 0, y: 0, width: UIScreen.mainWidth, height: min(UIScreen.mainWidth, UIScreen.mainHeight)))
    
    private let tableView = MomentsTweetTableView()
    
    private let tweetProvider = MomentsTweetProvider()
    
    // MARK: Override
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeSubviews()
        loadScripts()
        tweetProvider.updateDataSource()
    }
}

// MARK: - Private
private extension MomentsViewController {
    
    func initializeSubviews() {
        view.backgroundColor = .white
        
        let refreshHeader = MJRefreshNormalHeader { [weak self] in
            self?.tweetProvider.refresh.accept(())
        }
        refreshHeader?.stateLabel.isHidden = true
        refreshHeader?.lastUpdatedTimeLabel.isHidden = true
        tableView.mj_header = refreshHeader
        
        let loadmoreFooter = MJRefreshAutoNormalFooter(refreshingBlock: { [weak self] in
            self?.tweetProvider.loadmore.accept(())
        })
        loadmoreFooter?.isHidden = true
        loadmoreFooter?.endRefreshingWithNoMoreData()
        tableView.mj_footer = loadmoreFooter
        
        tableView.tableHeaderView = topView
        tableView.dataSource = tweetProvider
        tableView.delegate = tweetProvider
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        if let header = tableView.mj_header {
            tableView.bringSubviewToFront(header)
        }
    }
    
    func loadScripts() {
        tweetProvider.tweets.subscribeNext(on: { [unowned self] _ in
            self.tableView.reloadData()
        }).disposed(by: rx.dsbag)
        
        tweetProvider.pageControl.subscribeNext(on: { [unowned self] isRefresh, hasData, hasMore in
            if isRefresh {
                self.tableView.mj_header?.endRefreshing()
                self.tableView.mj_footer?.isHidden = false
            } else {
                self.tableView.mj_footer?.endRefreshing()
            }
            if hasMore {
                self.tableView.mj_footer?.resetNoMoreData()
            } else {
                self.tableView.mj_footer?.endRefreshingWithNoMoreData()
            }
        }).disposed(by: rx.dsbag)
    }
}
