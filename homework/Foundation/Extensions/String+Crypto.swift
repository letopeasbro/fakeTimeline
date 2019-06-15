//
//  String+Crypto.swift
//  homework
//
//  Created by 刘奕成 on 2019/6/15.
//  Copyright © 2019 Eason. All rights reserved.
//

import CommonCrypto

extension String {
    
    public var MD5: String {
        let cStr = cString(using: .utf8)!
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: 16)
        CC_MD5(cStr, (CC_LONG)(strlen(cStr)), buffer)
        var md5Result = ""
        for i in 0 ..< 16 {
            md5Result = md5Result.appendingFormat("%02x", buffer[i])
        }
        free(buffer)
        return md5Result
    }
}
