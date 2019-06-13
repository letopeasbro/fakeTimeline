//
//  UIFont+Conveniences.swift
//  homework
//
//  Created by 刘奕成 on 2019/6/13.
//  Copyright © 2019 Eason. All rights reserved.
//

import UIKit

extension UIFont {
    
    /// "PingFangSC-Regular"
    public static func regularFont(ofSize fontSize: CGFloat) -> UIFont {
        return UIFont(name: "PingFangSC-Regular", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)
    }
    
    /// "PingFangSC-Medium"
    public static func mediumFont(ofSize fontSize: CGFloat) -> UIFont {
        return UIFont(name: "PingFangSC-Medium", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)
    }
    
    /// "PingFangSC-Semibold"
    public static func semiboldFont(ofSize fontSize: CGFloat) -> UIFont {
        return UIFont(name: "PingFangSC-Semibold", size: fontSize) ?? UIFont.boldSystemFont(ofSize: fontSize)
    }
}
