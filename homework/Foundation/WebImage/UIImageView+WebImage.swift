//
//  UIImageView+WebImage.swift
//  homework
//
//  Created by 刘奕成 on 2019/6/15.
//  Copyright © 2019 Eason. All rights reserved.
//

import Foundation

fileprivate struct AssociatedKeys {
    static var webImageHolder = "UIImageView.webImageHolder"
}

extension UIImageView {
    
    private var webImageHolder: WebImageHolder? {
        get {
            if let holder = objc_getAssociatedObject(self, &AssociatedKeys.webImageHolder) as? WebImageHolder {
                return holder
            }
            let holder = WebImageHolder()
            objc_setAssociatedObject(self, &AssociatedKeys.webImageHolder, holder, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return holder
        }
    }
    
    func setImage(
        _ url: URL?,
        placeholder: UIImage?,
        progress: WebImageLoader.ProgressClosure? = nil,
        transform: WebImageLoader.TransformClosure? = nil,
        completion: @escaping WebImageLoader.CompletionClosure)
    {
        if let p = placeholder {
            self.image = p
        }
        guard let url = url else {
            self.image = placeholder
            return
        }
        webImageHolder?.requestImage(url, progress: progress, transform: transform, completion: completion)
    }
}
