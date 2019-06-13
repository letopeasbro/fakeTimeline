//
//  AvatarView.swift
//  homework
//
//  Created by 刘奕成 on 2019/6/13.
//  Copyright © 2019 Eason. All rights reserved.
//

import UIKit

class AvatarView: UIImageView {
    
    let cornerRadius: CGFloat
    
    init(cornerRadius v1: CGFloat = 0.0) {
        cornerRadius = v1
        super.init(frame: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public
extension AvatarView {
    
    /// 设置头像
    /// NOTE: 在确定AutoLayout布局完成后调用, 或传入sideLength以保证圆角能正确设置
    ///
    /// - Parameters:
    ///   - url: 头像地址
    ///   - sideLength: 头像视图边长, 传入nil则使用bounds.height
    func setAvatar(_ url: URL, sideLength: CGFloat? = nil) {
        
    }
}
