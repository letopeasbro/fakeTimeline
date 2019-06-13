//
//  MomentsTweetCell.swift
//  homework
//
//  Created by 刘奕成 on 2019/6/13.
//  Copyright © 2019 Eason. All rights reserved.
//

import UIKit

class MomentsTweetCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let avatarView = AvatarView(cornerRadius: 4.0)
    
    let nicknameLabel = UILabel(.withHex(0x606FA3), .semiboldFont(ofSize: 18))
    
    let canvasView = UIView()
    
    let commentsView = MomentsTweetCommentsView()
    
    func initializeSubviews() {
        selectionStyle = .none
        contentView.backgroundColor = .white
        
        contentView.addSubview(avatarView)
        avatarView.snp.makeConstraints { (make) in
            make.top.equalTo(contentView).offset(15)
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
            make.leading.equalTo(nicknameLabel)
            make.top.equalTo(nicknameLabel.snp.bottom).offset(8)
            make.trailing.equalTo(-12)
        }
        
        contentView.addSubview(commentsView)
        commentsView.snp.makeConstraints { (make) in
            make.leading.equalTo(canvasView).offset(-1)
            make.top.equalTo(canvasView.snp.bottom).offset(10)
            make.bottom.equalTo(contentView).offset(-10)
        }
    }
}
