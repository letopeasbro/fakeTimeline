//
//  MomentsTweetCell.swift
//  homework
//
//  Created by 刘奕成 on 2019/6/13.
//  Copyright © 2019 Eason. All rights reserved.
//

import UIKit

class MomentsTweetCell<Content>: UITableViewCell {
    
    /// 为子类提供的画布视图
    let canvasView = UIView()
    
    struct Model {
        let avatarURL: URL?
        let nickname: String?
        let content: Content
        let comments: [Moments.Comment]?
    }
    
    /// 渲染数据模型
    let model = PublishRelay<Model>()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initializeSubviews()
        loadScripts()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let avatarView = AvatarView(cornerRadius: 4.0)
    
    private let nicknameLabel = UILabel(.withHex(0x606FA3), .semiboldFont(ofSize: 18))
    
    private let commentsView = MomentsTweetCommentsView()
    
    func initializeSubviews() {
        selectionStyle = .none
        contentView.backgroundColor = .white
        
        avatarView.backgroundColor = .blue
        contentView.addSubview(avatarView)
        avatarView.snp.makeConstraints { (make) in
            make.top.equalTo(contentView).offset(15).priority(.high)
            make.leading.equalTo(12)
            make.size.equalTo(44)
        }
        
        contentView.addSubview(nicknameLabel)
        nicknameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(avatarView)
            make.leading.equalTo(avatarView.snp.trailing).offset(10)
            make.trailing.lessThanOrEqualTo(-12)
        }
        
        contentView.addSubview(canvasView)
        canvasView.snp.makeConstraints { (make) in
            make.top.equalTo(nicknameLabel.snp.bottom)
            make.leading.equalTo(nicknameLabel)
            make.trailing.equalTo(-12)
        }
        
        contentView.addSubview(commentsView)
        commentsView.snp.makeConstraints { (make) in
            make.top.equalTo(canvasView.snp.bottom)
            make.leading.trailing.equalTo(canvasView)
            make.bottom.equalTo(contentView).offset(-15).priority(.high)
        }
    }
    
    func loadScripts() {
        model.subscribeNext(on: { [unowned self] model in
            self.avatarView.setAvatar(model.avatarURL, sideLength: 44.0)
            self.nicknameLabel.text = model.nickname
            self.commentsView.config(model.comments)
        }).disposed(by: rx.dsbag)
    }
}
