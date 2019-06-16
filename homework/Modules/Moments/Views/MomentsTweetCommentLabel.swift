//
//  MomentsTweetCommentLabel.swift
//  homework
//
//  Created by 刘奕成 on 2019/6/15.
//  Copyright © 2019 Eason. All rights reserved.
//

import Foundation

class MomentsTweetCommentLabel: UILabel {
    
    init() {
        super.init(frame: .zero)
        textColor = .withHex(0x222222)
        font = .regularFont(ofSize: 16)
        numberOfLines = 0
        lineBreakMode = .byCharWrapping
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private
extension MomentsTweetCommentLabel {
    
    private func constructContent(_ sender: String, receiver: String = "", text: String) -> NSAttributedString {
        let at: String
        if receiver.count > 0 {
            at = " @ "
        } else {
            at = ""
        }
        let plain = "\(sender)\(at)\(receiver): \(text)"
        let content = NSMutableAttributedString(string: plain)
        let nameAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor(hexValue: 0x606FA3),
            NSAttributedString.Key.font: UIFont.semiboldFont(ofSize: 16)
        ]
        content.addAttributes(nameAttributes, range: NSMakeRange(0, sender.count))
        content.addAttributes(nameAttributes, range: NSMakeRange(sender.count + at.count, receiver.count))
        return content
    }
}

// MARK: - Public
extension MomentsTweetCommentLabel {
    
    func config(_ senderName: String, receiverName: String? = nil, text: String) {
        let content = constructContent(senderName, receiver: receiverName ?? "", text: text)
        attributedText = content
    }
}
