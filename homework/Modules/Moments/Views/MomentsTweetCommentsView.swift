//
//  MomentsTweetCommentsView.swift
//  homework
//
//  Created by 刘奕成 on 2019/6/13.
//  Copyright © 2019 Eason. All rights reserved.
//

import UIKit

class MomentsTweetCommentsView: UIView {
    
    static let backgroundImage: UIImage? = {
        let img = UIImage(named: "moments_tweet_comments_bg")
        return img?.resizableImage(withCapInsets: UIEdgeInsets(top: 4, left: 5, bottom: 4, right: 5), resizingMode: .stretch)
    }()
    
    private let backgroundImageView: UIImageView = {
        let v = UIImageView(image: MomentsTweetCommentsView.backgroundImage)
        v.isHidden = true
        return v
    }()
    
    private typealias Label = MomentsTweetCommentLabel
    
    private var reusableLabels: [Label] = []
    
    init() {
        super.init(frame: .zero)
        initializeSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private
extension MomentsTweetCommentsView {
    
    private func initializeSubviews() {
        addSubview(backgroundImageView)
        backgroundImageView.snp.makeConstraints { (make) in
            make.top.leading.lessThanOrEqualToSuperview()
            make.bottom.trailing.greaterThanOrEqualToSuperview()
        }
    }
    
    private func ensureReusableLabelsEnough(_ needs: Int) {
        guard reusableLabels.count < needs else { return }
        var count = needs - reusableLabels.count
        while count > 0 {
            let label = Label()
            reusableLabels.append(label)
            count -= 1
        }
        assert(reusableLabels.count == needs)
    }
    
    private func dequeueNeededLabels(_ needs: Int) -> [Label] {
        assert(reusableLabels.count >= needs, "请确保可复用的Label足够")
        let labels = Array(reusableLabels[0 ..< needs])
        // 将未取出的Label清除
        Array(reusableLabels[needs ..< reusableLabels.count]).forEach({
            $0.removeFromSuperview()
        })
        return labels
    }
    
    private func relayoutLabels(_ labels: [Label]) {
        var last: Label?
        labels.forEach { (label) in
            defer {
                last = label
            }
            guard label.superview == nil else { return }
            addSubview(label)
            label.snp.makeConstraints({ (make) in
                if let theLast = last {
                    make.top.equalTo(theLast.snp.bottom)
                    make.leading.trailing.equalTo(theLast)
                } else {
                    // 本视图第一个锚点label
                    make.top.equalTo(4)
                    make.leading.equalTo(5)
                    make.trailing.equalTo(-5)
                }
                make.height.greaterThanOrEqualTo(30)
                make.bottom.lessThanOrEqualTo(-4)
            })
        }
    }
}

// MARK: - Public
extension MomentsTweetCommentsView {
    
    struct Comment {
        let senderName: String
        let receiverName: String?
        let content: String
    }
    
    func config(_ comments: [Comment]?) {
        let commentsCount = comments?.count ?? 0
        backgroundImageView.isHidden = commentsCount <= 0
        ensureReusableLabelsEnough(commentsCount)
        let labels = dequeueNeededLabels(commentsCount)
        labels.enumerated().forEach { (idx, label) in
            guard let cmts = comments else { return }
            let comment = cmts[idx]
            label.config(comment.senderName, receiverName: nil, text: comment.content)
        }
        relayoutLabels(labels)
    }
}
