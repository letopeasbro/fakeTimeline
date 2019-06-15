//
//  NineGridView.swift
//  homework
//
//  Created by 刘奕成 on 2019/6/15.
//  Copyright © 2019 Eason. All rights reserved.
//

import Foundation

class NineGridView: UIView {
    
    private let gridView: SquaredBoxView<UIImageView> = {
        let v = SquaredBoxView<UIImageView>(squaresCount: 9)
        v.interval = 5.0
        return v
    }()
    
    init() {
        super.init(frame: .zero)
        initializeSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private
extension NineGridView {
    
    private func initializeSubviews() {
        addSubview(gridView)
        gridView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: - Public
extension NineGridView {
    
    func requestPictures(_ urls: [URL]) {
        let count = urls.count
        gridView.showSquaresCount(UInt(count))
        for (idx, url) in urls.enumerated() {
            print("下载图片:\(url)")
            gridView.squareView(at: idx)?.backgroundColor = .red
        }
        layoutIfNeeded()
    }
}
