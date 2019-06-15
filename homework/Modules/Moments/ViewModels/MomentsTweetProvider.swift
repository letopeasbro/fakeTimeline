//
//  MomentsTweetProvider.swift
//  homework
//
//  Created by 刘奕成 on 2019/6/13.
//  Copyright © 2019 Eason. All rights reserved.
//

import Foundation

class MomentsTweetProvider: BaseViewModel {
    
    let tweets = BehaviorRelay<[Moments.Tweet]>(value: [])
    
    private typealias Tweet = Moments.Tweet
    
    private var dataSource: [Tweet] = []
    
    // MARK: Override
    
    override func loadScripts() {
        super.loadScripts()
    }
}

// MARK: - Private
extension MomentsTweetProvider {
    
    private enum ModelType {
        case invalid
        case text
        case photo
        case multipicture
        
        init(_ tweet: Tweet) {
            let content = tweet.content
            let imagesCount = tweet.images?.count ?? 0
            if content == nil && imagesCount <= 0 {
                self = .invalid
            } else if imagesCount == 1 {
                self = .photo
            } else if imagesCount > 1 {
                self = .multipicture
            } else {
                self = .text
            }
        }
    }
    
    private func checkIvalid(_ tweet: Tweet) -> Bool {
        return ModelType(tweet) != .invalid
    }
    
    private typealias TextModel = MomentsTweetTextCell.Model
    private typealias PhotoModel = MomentsTweetPhotoCell.Model
    private typealias MultipictureModel = MomentsTweetMultipictureCell.Model
    
    private func mapTextModel(_ tweet: Tweet) -> TextModel {
        assert(tweet.content != nil, "Tweet必须有内容")
        return TextModel(avatarURL: URL(string: tweet.sender?.avatarPath ?? ""),
                         nickname: tweet.sender?.nickname,
                         content: tweet.content ?? " ",
                         comments: tweet.comments)
    }
    
    private func mapPhotoModel(_ tweet: Tweet) -> PhotoModel {
        assert(tweet.images?.count == 1, "照片Tweet图片数量为1(参考微信)")
        let content = MomentsTweetPhotoCell.Content(text: tweet.content ?? " ",
                                                    photoURL: tweet.images?.first?.url)
        return PhotoModel(avatarURL: URL(string: tweet.sender?.avatarPath ?? ""),
                          nickname: tweet.sender?.nickname,
                          content: content,
                          comments: tweet.comments)
    }
    
    private func mapMultipictureModel(_ tweet: Tweet) -> MultipictureModel {
        let urls = tweet.images?.map({ $0.url }) ?? []
        assert(urls.count > 1, "九宫格Tweet图片数量应该大于1张(参考微信)")
        let content = MomentsTweetMultipictureCell.Content(text: tweet.content,
                                                           pictureURLs: urls)
        return MultipictureModel(avatarURL: URL(string: tweet.sender?.avatarPath ?? ""),
                                 nickname: tweet.sender?.nickname,
                                 content: content,
                                 comments: tweet.comments)
    }
}

// MARK: - Public
extension MomentsTweetProvider {
    
    func updateDataSource() {
        Moments.provider.rx.request(.tweets)
            .map([Moments.Tweet].self)
            .retry(3)
            .filter({ (response) -> Bool in
                // 就目前返回的数据模型分析, 以是否存在可用数据判断结果是否有效
                return response.count > 0
            })
            .subscribe(onSuccess: { [unowned self] (response) in
                self.dataSource = response
            })
            .disposed(by: rx.dsbag)
    }
}

// MARK: - UITableViewDataSource
extension MomentsTweetProvider: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tweet = tweets.value[indexPath.row]
        let modelType = ModelType(tweet)
        switch modelType {
        case .invalid:
            return UITableViewCell()
        case .text:
            let cell: MomentsTweetTextCell = tableView.dequeueReusableCell()
            cell.model.accept(mapTextModel(tweet))
            return cell
        case .photo:
            let cell: MomentsTweetPhotoCell = tableView.dequeueReusableCell()
            cell.model.accept(mapPhotoModel(tweet))
            return cell
        case .multipicture:
            let cell: MomentsTweetMultipictureCell = tableView.dequeueReusableCell()
            cell.model.accept(mapMultipictureModel(tweet))
            return cell
        }
    }
}

// MARK: - UITableViewDelegate
extension MomentsTweetProvider: UITableViewDelegate {}
