//
//  UIColor+Conveniences.swift
//  homework
//
//  Created by 刘奕成 on 2019/6/13.
//  Copyright © 2019 Eason. All rights reserved.
//

import UIKit

extension UIColor {
    
    /// 十六进制值初始化颜色
    convenience init(hexValue: Int, alpha: CGFloat = 1.0) {
        let redValue   = CGFloat((hexValue & 0xFF0000) >> 16) / 255.0
        let greenValue = CGFloat((hexValue & 0xFF00) >> 8) / 255.0
        let blueValue  = CGFloat(hexValue & 0xFF) / 255.0
        self.init(red: redValue, green: greenValue, blue: blueValue, alpha: alpha)
    }
    
    static func withHex(_ hexValue: Int, alpha: CGFloat = 1.0) -> UIColor {
        return UIColor(hexValue: hexValue, alpha: alpha)
    }
}
