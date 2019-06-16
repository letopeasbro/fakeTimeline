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
        loadScripts()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let background = CALayer()
    
    private let profileView: UIImageView = {
        let v = UIImageView()
        v.contentMode = .scaleAspectFill
        v.clipsToBounds = true
        return v
    }()
    
    private let avatarView = AvatarView(cornerRadius: 5.0)
    
    private let nameLabel = UILabel(.white, .semiboldFont(ofSize: 18))
    
    struct Model {
        let profileURL: URL?
        let avatarURL: URL?
        let name: String?
    }
    
    let model = PublishRelay<Model>()
    
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
        
        profileView.backgroundColor = .white
        addSubview(profileView)
        profileView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(snp.top).offset(320)
            make.height.equalToSuperview()
        }
        
        addSubview(avatarView)
        avatarView.snp.makeConstraints { (make) in
            make.trailing.equalTo(-12)
            make.bottom.equalTo(profileView).offset(20)
            make.size.equalTo(70)
        }
        
        addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(avatarView.snp.top).offset(25)
            make.leading.greaterThanOrEqualToSuperview().priority(.low)
            make.trailing.equalTo(avatarView.snp.leading).offset(-20)
        }
    }
    
    private func loadScripts() {
        model.subscribeNext(on: { [unowned self] model in
            self.setProfileImage(model.profileURL)
            self.avatarView.setAvatar(model.avatarURL, sideLength: 70)
            self.nameLabel.text = model.name
        }).disposed(by: rx.dsbag)
    }
    
    private func setProfileImage(_ url: URL?) {
        profileView.setImage(url, placeholder: nil, progress: nil, transform: { (image) -> UIImage? in
            let size = self.profileView.bounds.size
            return image.byResize(to: size)
        }) { (image, _, _, _) in
            self.profileView.image = image
        }
    }
}
