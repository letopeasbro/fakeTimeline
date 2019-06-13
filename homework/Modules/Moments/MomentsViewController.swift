//
//  MomentsViewController.swift
//  homework
//
//  Created by 刘奕成 on 2019/6/13.
//  Copyright © 2019 Eason. All rights reserved.
//

import UIKit

class MomentsViewController: UIViewController {
    
    private let topView = MomentsTopView(frame: CGRect(x: 0, y: -44, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width))
    
    private let tableView = MomentsTweetTableView()
    
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
        
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        
        tableView.tableHeaderView = topView
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    func loadScripts() {
        
    }
}
