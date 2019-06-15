//
//  UIImageView+WebImage.swift
//  homework
//
//  Created by 刘奕成 on 2019/6/15.
//  Copyright © 2019 Eason. All rights reserved.
//

import Foundation

fileprivate struct AssociatedKeys {
    static var webImageLoader = "UIImageView.webImageLoader"
}

extension UIImageView {
    
    private var webImageLoader: WebImageLoader? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.webImageLoader) as? WebImageLoader
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.webImageLoader, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func setImage(
        _ url: URL?,
        placeholder: UIImage?,
        progress: WebImageLoader.ProgressClosure? = nil,
        transform: WebImageLoader.TransformClosure? = nil,
        completion: @escaping WebImageLoader.CompletionClosure)
    {
        self.image = placeholder
        guard let url = url else { return }
        if let loader = webImageLoader {
            loader.cancel()
        }
        let loader = WebImageManager.shared.requestImage(url, progress: progress, transform: transform) { [weak self] (image, url, fromType, state) in
            self?.webImageLoader = nil
            if case .canceled = state {
                return
            }
            completion(image, url, fromType, state)
        }
        webImageLoader = loader
    }
}
