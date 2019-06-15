//
//  User+Models.swift
//  homework
//
//  Created by 刘奕成 on 2019/6/15.
//  Copyright © 2019 Eason. All rights reserved.
//

import Foundation

// MARK: - Profile
extension User {
    
    struct Profile: Decodable {}
}

// MARK: - Card
extension User {
    
    struct Card: Decodable {
        
        let username: String?
        
        let nickname: String?
        
        let avatarPath: String?
        
        enum CodingKeys: String, CodingKey {
            case username
            case nickname = "nick"
            case avatarPath = "avatar"
        }
        
        var showName: String? {
            return nickname ?? username
        }
    }
}
