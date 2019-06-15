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
}

// MARK: - Private
extension MomentsTweetTableView {
    
    private func initializeSubviews() {
        backgroundColor = .white
        showsHorizontalScrollIndicator = false
        separatorInset = UIEdgeInsets(top: 0, left: -15, bottom: 0, right: 0)
        estimatedRowHeight = 160.0
        estimatedSectionHeaderHeight = 0.0
        estimatedSectionFooterHeight = 0.0
        register(MomentsTweetTextCell.self)
        register(MomentsTweetPhotoCell.self)
        register(MomentsTweetMultipictureCell.self)
        tableFooterView = UIView()
    }
}
