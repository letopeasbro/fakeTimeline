//
//  MomentsTweetTableView.swift
//  homework
//
//  Created by 刘奕成 on 2019/6/14.
//  Copyright © 2019 Eason. All rights reserved.
//

import UIKit

class MomentsTweetTableView: UITableView {

    init() {
        super.init(frame: .zero, style: .plain)
        initializeSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initializeSubviews() {
        backgroundColor = .white
        showsHorizontalScrollIndicator = false
        separatorStyle = .none
        estimatedRowHeight = 160.0
        estimatedSectionHeaderHeight = 0.0
        estimatedSectionFooterHeight = 0.0
        register(MomentsTweetTextCell.self, forCellReuseIdentifier: "\(MomentsTweetTextCell.self)")
        register(MomentsTweetPhotoCell.self, forCellReuseIdentifier: "\(MomentsTweetPhotoCell.self)")
        register(MomentsTweetMultipictureCell.self, forCellReuseIdentifier: "\(MomentsTweetMultipictureCell.self)")
        tableFooterView = UIView()
    }
}
