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
    
    init(sideLength v1: CGFloat) {
        sideLength = v1
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
            make.edges.equalToSuperview()
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
            imgView.setImage(url, placeholder: nil, transform: { (image) -> UIImage? in
                let l = self.gridView.squareLength
                let frame = CGRect(origin: .zero, size: CGSize(width: l, height: l))
                UIGraphicsBeginImageContextWithOptions(frame.size, false, image.scale)
                image.draw(in: frame)
                let result = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                return result
            }, completion: { (image, _, _, _) in
                imgView.image = image
            })
        }
        layoutIfNeeded()
    }
}
