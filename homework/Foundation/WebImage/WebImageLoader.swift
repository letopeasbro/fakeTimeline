//
//  WebImageLoader.swift
//  homework
//
//  Created by 刘奕成 on 2019/6/15.
//  Copyright © 2019 Eason. All rights reserved.
//

import Foundation

enum WebImageLoadFromType {
    case none
    case memory
    case disk
    case remote
}

enum WebImageLoadState {
    case finished
    case failed(Error?)
    case canceled
}

class WebImageLoader: NSObject {
    
    private let cacheKey: String
    private let request: URLRequest
    private let diskCacheURL: URL?
    
    /// 图片加载进度回调, 目前未使用, 保留以便扩展
    typealias ProgressClosure = (Int64, Int64) -> Void
    private let progress: ProgressClosure?
    
    typealias TransformClosure = (UIImage) -> UIImage?
    private let transform: TransformClosure?
    
    typealias CompletionClosure = (UIImage?, URL?, WebImageLoadFromType, WebImageLoadState) -> Void
    private let completion: CompletionClosure
    
    init(
        cacheKey v0: String,
        request v1: URLRequest,
        diskCacheURL v2: URL?,
        progress v4: ProgressClosure? = nil,
        transform v3: TransformClosure? = nil,
        completion v5: @escaping CompletionClosure)
    {
        cacheKey = v0
        request = v1
        diskCacheURL = v2
        transform = v3
        progress = v4
        completion = v5
    }
    
    private var session: URLSession {
        return URLSession.shared
    }
    
    private var responseData = Data()
}

// MARK: - Private
extension WebImageLoader {
    
    func transform(_ image: UIImage) -> UIImage? {
        var transformedImage: UIImage?
        if let transformClosure = transform {
            if pthread_main_np() != 0 {
                transformedImage = transformClosure(image)
            } else {
                DispatchQueue.main.sync {
                    transformedImage = transformClosure(image)
                }
            }
        } else {
            transformedImage = image
        }
        return transformedImage
    }
    
    func done(_ image: UIImage?, _ url: URL?, _ fromType: WebImageLoadFromType, _ state: WebImageLoadState) {
        DispatchQueue.main.async {
            self.completion(image, url, fromType, state)
        }
    }
}

// MARK: - Memory Cache
extension WebImageLoader {
    
    private static var memoryCachedImages: [String: UIImage] = [:]
    
    private static let memoryCacheLock = NSRecursiveLock()
    
    private static func cacheImage(_ image: UIImage, toMemory key: String) {
        defer {
            memoryCacheLock.unlock()
        }
        memoryCacheLock.lock()
        memoryCachedImages[key] = image
    }
    
    private static func readImageFromMemory(_ key: String) -> UIImage? {
        return memoryCachedImages[key]
    }
}

// MARK: - Disk Cache
extension WebImageLoader {
    
    private func cacheImageData(_ data: Data, toDisk key: String) {
        guard let cacheURL = diskCacheURL else { return }
        try? data.write(to: cacheURL.appendingPathComponent(cacheKey, isDirectory: false))
    }
    
    private func readImageFromDisk() -> UIImage? {
        guard let cacheURL = diskCacheURL else { return nil }
        guard let data = try? Data(contentsOf: cacheURL.appendingPathComponent(cacheKey, isDirectory: false)) else { return nil }
        return UIImage(data: data, scale: UIScreen.main.scale)
    }
}

// MARK: - Network Response
extension WebImageLoader {
    
    private func handleDiskCachedImage(_ image: UIImage) {
        guard let transformed = transform(image) else {
            done(nil, request.url, .none, .canceled)
            return
        }
        WebImageLoader.cacheImage(transformed, toMemory: cacheKey)
        done(transformed, request.url, .disk, .finished)
    }
    
    private func handleNetworkResponse(_ data: Data) {
        guard let image = UIImage(data: data, scale: UIScreen.main.scale) else { return }
        guard let transformed = transform(image) else {
            done(nil, request.url, .none, .canceled)
            return
        }
        // 缓存存处理后的图片
        WebImageLoader.cacheImage(transformed, toMemory: cacheKey)
        done(transformed, request.url, .remote, .finished)
        // 硬盘存原图
        cacheImageData(data, toDisk: cacheKey)
    }
}

// MARK: - Control
extension WebImageLoader {
    
    func start() {
        // memory
        if let image = WebImageLoader.readImageFromMemory(cacheKey) {
            done(image, request.url, .memory, .finished)
            return
        }
        // disk
        if let image = readImageFromDisk() {
            handleDiskCachedImage(image)
            return
        }
        // network
        session.dataTask(with: request) { (data, response, error) in
            if let d = data {
                self.handleNetworkResponse(d)
            } else {
                self.done(nil, self.request.url, .none, .failed(error))
            }
        }.resume()
    }
    
    func cancel() {
        done(nil, request.url, .none, .canceled)
    }
}
