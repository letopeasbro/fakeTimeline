//
//  MomentsTweetPhotoCell.swift
//  homework
//
//  Created by 刘奕成 on 2019/6/13.
//  Copyright © 2019 Eason. All rights reserved.
//

import Foundation

// 用来展示单图片Tweet的类(参考微信), 但数据模型里没有宽高参数, 异步加载图片后再刷新cell的效果也不好, 就暂时搁置
class MomentsTweetPhotoCell: MomentsTweetCell<MomentsTweetPhotoCell.Content> {
    
    struct Content {
        let text: String?
        let photoURL: URL?
        let width: CGFloat
        let height: CGFloat
    }
    
    private let contentLabel = UILabel(.withHex(0x222222), .regularFont(ofSize: 18), numberOfLines: 0)
    
    private let photoView = UIImageView()
    
    override func initializeSubviews() {
        super.initializeSubviews()
        
        contentLabel.lineBreakMode = .byCharWrapping
        canvasView.addSubview(contentLabel)
        contentLabel.snp.makeConstraints { (make) in
            make.leading.top.trailing.equalToSuperview()
        }
        
        canvasView.addSubview(photoView)
        photoView.snp.makeConstraints { (make) in
            make.top.equalTo(contentLabel.snp.bottom).offset(10)
            make.leading.bottom.trailing.equalToSuperview()
        }
    }
    
    override func loadScripts() {
        super.loadScripts()
        
        model.subscribeNext(on: { [unowned self] model in
            self.contentLabel.text = model.content.text
            self.photoView.setImage(model.content.photoURL, placeholder: nil, transform: nil, completion: { (image, _, _, _) in
                self.photoView.image = image
            })
        }).disposed(by: rx.dsbag)
    }
}
