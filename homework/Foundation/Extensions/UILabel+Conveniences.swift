//
//  UILabel+Conveniences.swift
//  homework
//
//  Created by 刘奕成 on 2019/6/13.
//  Copyright © 2019 Eason. All rights reserved.
//

import UIKit

extension UILabel {
    
    convenience init(_ textColor: UIColor, _ font: UIFont, textAlignment: NSTextAlignment = .left) {
        self.init(frame: .zero)
        self.textColor = textColor
        self.font = font
        self.textAlignment = textAlignment
    }
    
    convenience init(_ textColor: UIColor, _ font: UIFont, numberOfLines: Int) {
        self.init(frame: .zero)
        self.textColor = textColor
        self.font = font
        self.numberOfLines = numberOfLines
    }
}
