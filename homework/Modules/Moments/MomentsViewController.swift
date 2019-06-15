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
    }
}

// MARK: - Private
private extension MomentsViewController {
    
    func initializeSubviews() {
        view.backgroundColor = .white
        
        tableView.tableHeaderView = topView
        tableView.dataSource = tweetProvider
        tableView.delegate = tweetProvider
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    func loadScripts() {
        
    }
}
