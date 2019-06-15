//
//  SquaredBoxView.swift
//  homework
//
//  Created by 刘奕成 on 2019/6/15.
//  Copyright © 2019 Eason. All rights reserved.
//

import UIKit
import SnapKit

class SquaredBoxView<Square>: UIView where Square: UIView {
    
    var interval: CGFloat = 0.0
    
    private let squaresCount: Int
    
    private var shouldShowSquaresCount: UInt
    
    init(squaresCount v1: Int) {
        let r = Int(sqrt(Double(v1)))
        assert(v1 > 0 && r * r == v1, "方块数量设置错误")
        squaresCount = v1
        shouldShowSquaresCount = UInt(v1)
        super.init(frame: .zero)
        initializeSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let originTag = 2918
    
    // MARK: Override
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        subviews.forEach({ $0.snp.removeConstraints() })
        let countPerLine = Int(sqrt(Double(squaresCount)))
        let length: CGFloat = (bounds.width - CGFloat(countPerLine - 1) * interval) / CGFloat(countPerLine)
        for i in 0 ..< squaresCount {
            if let square = squareView(at: i) {
                guard i < shouldShowSquaresCount else { continue }
                let topInset = CGFloat(i / countPerLine) * (interval + length)
                let leadingInset = CGFloat(i % countPerLine) * (interval + length)
                square.snp.makeConstraints { (make) in
                    make.top.equalTo(topInset)
                    make.leading.equalTo(leadingInset)
                    if i % countPerLine == countPerLine - 1 {
                        make.trailing.equalToSuperview()
                    } else {
                        make.trailing.lessThanOrEqualToSuperview()
                    }
                    if i == shouldShowSquaresCount - 1 {
                        make.bottom.equalToSuperview()
                    } else {
                        make.bottom.lessThanOrEqualToSuperview()
                    }
                    make.size.equalTo(length)
                }
            }
        }
    }
}

// MARK: - Private
extension SquaredBoxView {
    
    private func initializeSubviews() {
        for i in 0 ..< squaresCount {
            let squareView = Square()
            squareView.tag = originTag + i
            squareView.backgroundColor = .white
            addSubview(squareView)
        }
    }
}

// MARK: - Public
extension SquaredBoxView {
    
    func squareView(at index: Int) -> Square? {
        return viewWithTag(originTag + index) as? Square
    }
    
    func showSquaresCount(_ count: UInt) {
        shouldShowSquaresCount = count
        setNeedsLayout()
    }
}
