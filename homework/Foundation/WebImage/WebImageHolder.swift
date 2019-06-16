//
//  WebImageHolder.swift
//  homework
//
//  Created by 刘奕成 on 2019/6/16.
//  Copyright © 2019 Eason. All rights reserved.
//

import Foundation

class WebImageHolder: NSObject {
    
    private var progress: WebImageLoader.ProgressClosure?
    
    private var transform: WebImageLoader.TransformClosure?
    
    private var completion: WebImageLoader.CompletionClosure?
    
    private var theLastURL: URL?
    
    private var loaders: [URL: WebImageLoader] = [:]
}

extension WebImageHolder {
    
    func requestImage(
        _ url: URL,
        progress: WebImageLoader.ProgressClosure? = nil,
        transform: WebImageLoader.TransformClosure? = nil,
        completion: @escaping WebImageLoader.CompletionClosure)
    {
        let loader = WebImageManager.shared.requestImage(url, progress: progress, transform: transform) { [weak self] (image, responseURL, fromType, state) in
            if self?.theLastURL == url {
                completion(image, responseURL, fromType, state)
            }
            self?.loaders[url] = nil
        }
        loaders[url] = loader
        theLastURL = url
    }
}
