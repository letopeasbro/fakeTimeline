//
//  MomentsTopView.swift
//  homework
//
//  Created by 刘奕成 on 2019/6/14.
//  Copyright © 2019 Eason. All rights reserved.
//

import UIKit

class MomentsTopView: UIView {
    
    /// 封面收起的高度
    private let packupHeight: CGFloat

    init() {
        packupHeight = 55.0
        super.init(frame: CGRect(x: 0, y: 0, width: UIScreen.mainWidth, height: UIScreen.mainHeight - packupHeight))
        initializeSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let profileView: UIImageView = {
        let v = UIImageView()
        v.contentMode = .scaleAspectFill
        return v
    }()
    
    let avatarView = AvatarView(cornerRadius: 5.0)
    
    func initializeSubviews() {
        backgroundColor = .withHex(0x888888)
        
        let background = CALayer()
        background.backgroundColor = UIColor(hexValue: 0x333333).cgColor
        background.frame = CGRect(x: 0, y: -packupHeight - UIScreen.mainHeight, width: UIScreen.mainWidth, height: UIScreen.mainHeight + packupHeight)
        layer.addSublayer(background)
        layer.masksToBounds = false
        
        profileView.frame = CGRect(x: 0, y: -packupHeight, width: UIScreen.mainWidth, height: UIScreen.mainHeight)
        addSubview(profileView)
        profileView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        addSubview(avatarView)
        avatarView.snp.makeConstraints { (make) in
            make.bottom.equalTo(profileView).offset(20)
            make.trailing.equalTo(-12)
            make.size.equalTo(70)
        }
    }
    
    // MARK: Override
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if avatarView.frame.contains(point) {
            return avatarView
        }
        return super.hitTest(point, with: event)
    }
}
