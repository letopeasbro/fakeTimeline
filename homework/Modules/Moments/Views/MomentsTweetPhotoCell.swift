//
//  MomentsTweetPhotoCell.swift
//  homework
//
//  Created by 刘奕成 on 2019/6/13.
//  Copyright © 2019 Eason. All rights reserved.
//

import Foundation

class MomentsTweetPhotoCell: MomentsTweetCell<MomentsTweetPhotoCell.Content> {
    
    struct Content {
        let text: String?
        let photoURL: URL?
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
            print("下载图片:\(model.content.photoURL)")
        }).disposed(by: rx.dsbag)
    }
}