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
    func setAvatar(_ url: URL?, sideLength: CGFloat? = nil) {
        let cornerRatio = cornerRadius / (sideLength ?? bounds.height)
        setImage(url, placeholder: nil, transform: { (image) -> UIImage? in
            let frame = CGRect(origin: .zero, size: image.size)
            UIGraphicsBeginImageContextWithOptions(frame.size, false, image.scale)
            let path = UIBezierPath(roundedRect: frame, cornerRadius: image.size.height * cornerRatio)
            path.addClip()
            image.draw(in: frame)
            let result = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return result
        }) { (image, _, fromType, state) in
            self.image = image
        }
    }
}
