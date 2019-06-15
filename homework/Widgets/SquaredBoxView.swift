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
    
    private(set) var squareBox = [Square]()
    
    private let squaresCount: Int
    
    private let sideLength: CGFloat
    
    init(squaresCount v1: Int, sideLength v2: CGFloat) {
        let r = Int(sqrt(Double(v1)))
        assert(v1 > 0 && r * r == v1, "方块数量设置错误")
        squaresCount = v1
        sideLength = v2
        super.init(frame: .zero)
        initializeSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private
extension SquaredBoxView {
    
    private func initializeSubviews() {
        for _ in 0 ..< squaresCount {
            let squareView = Square()
            addSubview(squareView)
            squareBox.append(squareView)
        }
    }
    
    private func dequeueNeededSquares(_ needs: Int) -> [Square] {
        let count = squareBox.count < needs ? squareBox.count : needs
        let squares = Array(squareBox[0 ..< count])
        // 将未取出的Label约束清除
        Array(squareBox[count ..< squareBox.count]).forEach({
            $0.constraints.forEach({ $0.isActive = false })
        })
        return squares
    }
    
    private func relayoutSquares(_ squares: [Square]) {
        let countPerLine = Int(sqrt(Double(squaresCount)))
        var vConstraintItem: ConstraintItem = snp.top
        var hConstraintItem: ConstraintItem = snp.leading
        squares.enumerated().forEach { (i, square) in
            defer {
                hConstraintItem = square.snp.trailing
                if i % countPerLine == countPerLine - 1 {
                    // 行尾
                    vConstraintItem = square.snp.bottom
                    hConstraintItem = snp.leading
                }
            }
            guard square.constraints.count == 0 else { return }
            // 保证垂直方向上的间隔
            let topInset = i / countPerLine > 0 ? 5 : 0
            // 保证水平方向上的间隔
            let leadingInset = i % countPerLine > 0 ? 5 : 0
            square.snp.makeConstraints({ (make) in
                make.top.equalTo(vConstraintItem).offset(topInset)
                make.leading.equalTo(hConstraintItem).offset(leadingInset)
                if i % countPerLine == countPerLine - 1 {
                    make.trailing.equalToSuperview()
                } else {
                    make.trailing.lessThanOrEqualToSuperview()
                }
                if i / countPerLine == countPerLine - 1 {
                    make.bottom.equalToSuperview()
                } else {
                    make.bottom.lessThanOrEqualToSuperview()
                }
                make.size.equalTo(squareLength)
            })
        }
    }
}

// MARK: - Public
extension SquaredBoxView {
    
    var squareLength: CGFloat {
        let countPerLine = Int(sqrt(Double(squaresCount)))
        return (sideLength - CGFloat(countPerLine - 1) * interval) / CGFloat(countPerLine)
    }
    
    func showSquaresCount(_ count: Int) {
        let squares = dequeueNeededSquares(Int(count))
        relayoutSquares(squares)
    }
}
