//
//  MomentsTweetProvider.swift
//  homework
//
//  Created by 刘奕成 on 2019/6/13.
//  Copyright © 2019 Eason. All rights reserved.
//

import Foundation

class MomentsTweetProvider: BaseViewModel {
    
    typealias Tweet = Moments.Tweet
    
    let tweets = BehaviorRelay<[Tweet]>(value: [])
    
    let pageControl = PublishRelay<(isRefresh: Bool, hasData: Bool, hasMore: Bool)>()
    
    let refresh = PublishRelay<Void>()
    
    let loadmore = PublishRelay<Void>()
    
    private var dataSource: [Tweet] = []
    
    private var next: Int = 0
    
    private let pageQueue = DispatchQueue(label: "MomentsTweetProvider.pageQueue")
    
    private var dataSourceRequestBag = DisposeBag()
    
    // MARK: Override
    
    override func loadScripts() {
        super.loadScripts()
        
        let request = { [unowned self] (isRefresh: Bool, start: Int, count: Int) in
            self.pageQueue.async {
                let (result, next, hasMore) = self.page(self.dataSource, start: start, count: count)
                self.next = next
                DispatchQueue.main.async {
                    let value: [Tweet]
                    if isRefresh {
                        value = result
                    } else {
                        value = self.tweets.value + result
                    }
                    self.tweets.accept(value)
                    self.pageControl.accept((isRefresh, result.count > 0, hasMore))
                }
            }
        }
        
        Observable<Bool>.merge([
            refresh.doNext(on: { [unowned self] _ in self.next = 0 }).map({ true }),
            loadmore.map({ false })
        ]).map({ [unowned self] (isRefresh) in
            return (isRefresh, self.next, 5)
        }).subscribeNext(on: request).disposed(by: rx.dsbag)
    }
}

// MARK: - Page Control
extension MomentsTweetProvider {
    
    func page(
        _ dataSource: [Tweet],
        start: Int,
        count: Int) -> (result: [Tweet], next: Int, hasMore: Bool)
    {
        var result: [Tweet]
        var next = start + count
        var hasMore = true
        let totalCount = dataSource.count
        if totalCount <= start {
            result = []
            next = start
            hasMore = false
        } else if totalCount < next {
            result = Array(dataSource[start ..< totalCount]).filter({ self.checkTweet($0) })
            next = totalCount
            hasMore = false
        } else {
            result = Array(dataSource[start ..< next]).filter({ self.checkTweet($0) })
            if result.count < count {
                self.addPagedResult(&result, with: &next, from: dataSource, toPageCount: count)
            }
            if next >= dataSource.count {
                hasMore = false
            }
        }
        return (result, next, hasMore)
    }
    
    private func addPagedResult(
        _ pagedResult: inout [Tweet],
        with index: inout Int,
        from dataSource: [Tweet],
        toPageCount count: Int)
    {
        guard pagedResult.count < count else { return }
        guard dataSource.count > index else { return }
        let element = dataSource[index]
        if checkTweet(element) {
            pagedResult.append(element)
        }
        index += 1
        addPagedResult(&pagedResult, with: &index, from: dataSource, toPageCount: count)
    }
    
    private enum ModelType {
        case invalid
        case text
        case multipicture
        
        init(_ tweet: Tweet) {
            let content = tweet.content
            let imagesCount = tweet.images?.count ?? 0
            if content == nil && imagesCount <= 0 {
                self = .invalid
            } else if imagesCount > 0 {
                self = .multipicture
            } else {
                self = .text
            }
        }
    }
    
    func checkTweet(_ tweet: Tweet) -> Bool {
        return ModelType(tweet) != .invalid
    }
}
    
// MARK: - Map Model
extension MomentsTweetProvider {
    
    private typealias CommentModel = MomentsTweetCommentsView.Comment
    private typealias TextModel = MomentsTweetTextCell.Model
    private typealias MultipictureModel = MomentsTweetMultipictureCell.Model
    
    private func mapCommentModel(_ comment: Moments.Comment) -> CommentModel {
        return CommentModel(senderName: comment.sender?.showName ?? " ",
                            receiverName: nil,
                            content: comment.content ?? " ")
    }
    
    private func mapTextModel(_ tweet: Tweet) -> TextModel {
        assert(tweet.content != nil, "Tweet必须有内容")
        return TextModel(avatarURL: URL(string: tweet.sender?.avatarPath ?? ""),
                         nickname: tweet.sender?.showName ?? " ",
                         content: tweet.content ?? " ",
                         comments: tweet.comments?.map(mapCommentModel))
    }
    
    private func mapMultipictureModel(_ tweet: Tweet) -> MultipictureModel {
        let urls = tweet.images?.map({ $0.url }) ?? []
        assert(urls.count > 0, "九宫格Tweet图片数量应该大于0张")
        let content = MomentsTweetMultipictureCell.Content(text: tweet.content,
                                                           pictureURLs: urls)
        return MultipictureModel(avatarURL: URL(string: tweet.sender?.avatarPath ?? ""),
                                 nickname: tweet.sender?.showName ?? " ",
                                 content: content,
                                 comments: tweet.comments?.map(mapCommentModel))
    }
}

// MARK: - Public
extension MomentsTweetProvider {
    
    func updateDataSource() {
        dataSourceRequestBag = DisposeBag()
        Moments.provider.rx.request(.tweets)
            .map([Tweet].self)
            .retryWhen({ _ in Network.reachable })
            .filter({ (response) -> Bool in
                // 就目前返回的数据模型分析, 以是否存在可用数据判断结果是否有效
                return response.count > 0
            })
            .subscribe(onSuccess: { [unowned self] (response) in
                self.dataSource = response
                DispatchQueue.main.async {
                    if self.tweets.value.count == 0 {
                        self.refresh.accept(())
                    }
                }
            })
            .disposed(by: dataSourceRequestBag)
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
        case .multipicture:
            let cell: MomentsTweetMultipictureCell = tableView.dequeueReusableCell()
            cell.model.accept(mapMultipictureModel(tweet))
            return cell
        }
    }
}

// MARK: - UITableViewDelegate
extension MomentsTweetProvider: UITableViewDelegate {}
