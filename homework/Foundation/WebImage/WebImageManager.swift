//
//  WebImageManager.swift
//  homework
//
//  Created by 刘奕成 on 2019/6/15.
//  Copyright © 2019 Eason. All rights reserved.
//

import Foundation

class WebImageManager: NSObject {
    
    static let shared = WebImageManager()
    
    private override init() {
        super.init()
    }
    
    private lazy var diskCacheURL: URL? = {
        guard let path = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first else { return nil }
        var url = URL(fileURLWithPath: path)
        url.appendPathComponent("WebImages")
        if !FileManager.default.fileExists(atPath: url.path) {
            try? FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
        }
        return url
    }()
    
    private let queue: DispatchQueue = DispatchQueue(label: "WebImageManager.queue", qos: .background, attributes: .concurrent)
}

// MARK: - Public
extension WebImageManager {
    
    func requestImage(
        _ url: URL,
        progress: WebImageLoader.ProgressClosure? = nil,
        transform: WebImageLoader.TransformClosure? = nil,
        completion: @escaping WebImageLoader.CompletionClosure) -> WebImageLoader
    {
        let key = url.absoluteString.MD5
        var request = URLRequest(url: url)
        request.addValue("image/*;q=0.8", forHTTPHeaderField: "Accept")
        let loader = WebImageLoader(cacheKey: key, request: request, diskCacheURL: diskCacheURL, progress: progress, transform: transform, completion: completion)
        queue.async { [weak loader] in
            loader?.start()
        }
        return loader
    }
}

