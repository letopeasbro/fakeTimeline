//
//  NineGridView.swift
//  homework
//
//  Created by 刘奕成 on 2019/6/15.
//  Copyright © 2019 Eason. All rights reserved.
//

import Foundation

class NineGridView: UIView {
    
    private let sideLength: CGFloat
    
    private let contentInset: UIEdgeInsets
    
    init(sideLength v1: CGFloat, contentInset v2: UIEdgeInsets = .zero) {
        sideLength = v1
        contentInset = v2
        super.init(frame: .zero)
        initializeSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var gridView: SquaredBoxView<UIImageView> = {
        let v = SquaredBoxView<UIImageView>(squaresCount: 9, sideLength: sideLength)
        v.interval = 5.0
        return v
    }()
}

// MARK: - Private
extension NineGridView {
    
    private func initializeSubviews() {
        gridView.squareBox.forEach({
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
        })
        addSubview(gridView)
        gridView.snp.makeConstraints { (make) in
            make.edges.equalTo(contentInset)
        }
    }
}

// MARK: - Public
extension NineGridView {
    
    func requestPictures(_ urls: [URL?]) {
        let count = urls.count
        gridView.showSquaresCount(count)
        for (idx, url) in urls.enumerated() {
            let imgView = gridView.squareBox[idx]
            // 避免刷新前展示其他人的图片
            imgView.image = nil
            imgView.setImage(url, placeholder: nil, transform: { (image) -> UIImage? in
                let l = self.gridView.squareLength
                return image.byResize(to: CGSize(width: l, height: l))
            }, completion: { (image, _, _, _) in
                imgView.image = image
            })
        }
        layoutIfNeeded()
    }
}
