//
//  MomentsTweetMultipictureCell.swift
//  homework
//
//  Created by 刘奕成 on 2019/6/13.
//  Copyright © 2019 Eason. All rights reserved.
//

import Foundation

class MomentsTweetMultipictureCell: MomentsTweetCell<MomentsTweetMultipictureCell.Content> {
    
    struct Content {
        let text: String?
        let pictureURLs: [URL]
    }
    
    private let contentLabel = UILabel(.withHex(0x222222), .regularFont(ofSize: 18), numberOfLines: 0)
    
    private let pictureView = NineGridView()
    
    override func initializeSubviews() {
        super.initializeSubviews()
        
        contentLabel.lineBreakMode = .byCharWrapping
        canvasView.addSubview(contentLabel)
        contentLabel.snp.makeConstraints { (make) in
            make.leading.top.trailing.equalToSuperview()
        }
        
        canvasView.addSubview(pictureView)
        pictureView.snp.makeConstraints { (make) in
            make.top.equalTo(contentLabel.snp.bottom).offset(10)
            make.width.equalTo(250)
            make.leading.bottom.equalToSuperview()
        }
    }
    
    override func loadScripts() {
        super.loadScripts()
        
        model.subscribeNext(on: { [unowned self] model in
            self.contentLabel.text = model.content.text
            self.pictureView.requestPictures(model.content.pictureURLs)
        }).disposed(by: rx.dsbag)
    }
}
