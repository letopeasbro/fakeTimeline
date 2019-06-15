//
//  MomentsTopView.swift
//  homework
//
//  Created by 刘奕成 on 2019/6/14.
//  Copyright © 2019 Eason. All rights reserved.
//

import UIKit

class MomentsTopView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let background = CALayer()
    
    private let profileView: UIImageView = {
        let v = UIImageView()
        v.contentMode = .scaleAspectFill
        return v
    }()
    
    private let avatarView = AvatarView(cornerRadius: 5.0)
    
    // MARK: Override
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if avatarView.frame.contains(point) {
            return avatarView
        }
        return super.hitTest(point, with: event)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let regular = max(UIScreen.mainWidth, UIScreen.mainHeight)
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        background.frame = CGRect(x: 0, y: -regular, width: regular, height: regular)
        CATransaction.commit()
    }
}

// MARK: - Private
extension MomentsTopView {
    
    private func initializeSubviews() {
        backgroundColor = .white
        
        background.backgroundColor = UIColor(hexValue: 0x333333).cgColor
        layer.addSublayer(background)
        layer.masksToBounds = false
        
        profileView.backgroundColor = .red
        addSubview(profileView)
        profileView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(snp.top).offset(320)
            make.height.equalToSuperview()
        }
        
        avatarView.backgroundColor = .blue
        addSubview(avatarView)
        avatarView.snp.makeConstraints { (make) in
            make.trailing.equalTo(-12)
            make.bottom.equalTo(profileView).offset(20)
            make.size.equalTo(70)
        }
    }
}
