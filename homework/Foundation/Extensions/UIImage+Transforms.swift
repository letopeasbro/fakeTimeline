//
//  UIImage+Transforms.swift
//  homework
//
//  Created by 刘奕成 on 2019/6/16.
//  Copyright © 2019 Eason. All rights reserved.
//

import Foundation

extension UIImage {
    
    func byResize(to size: CGSize) -> UIImage? {
        guard size.width > 0, size.height > 0 else { return nil }
        let frame = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(frame.size, false, scale)
        draw(in: frame)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
}
