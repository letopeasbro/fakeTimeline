//
//  MomentsTweetTextCell.swift
//  homework
//
//  Created by 刘奕成 on 2019/6/13.
//  Copyright © 2019 Eason. All rights reserved.
//

import Foundation

class MomentsTweetTextCell: MomentsTweetCell<MomentsTweetTextCell.Content> {
    
    typealias Content = String
    
    private let contentLabel = UILabel(.withHex(0x222222), .regularFont(ofSize: 18), numberOfLines: 0)
    
    override func initializeSubviews() {
        super.initializeSubviews()
        
        contentLabel.lineBreakMode = .byCharWrapping
        canvasView.addSubview(contentLabel)
        contentLabel.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    override func loadScripts() {
        super.loadScripts()
        
        model.subscribeNext(on: { [unowned self] model in
            self.contentLabel.text = model.content
        }).disposed(by: rx.dsbag)
    }
}
