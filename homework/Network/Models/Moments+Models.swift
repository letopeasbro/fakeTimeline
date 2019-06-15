//
//  Moments+Models.swift
//  homework
//
//  Created by 刘奕成 on 2019/6/15.
//  Copyright © 2019 Eason. All rights reserved.
//

import Foundation

// MARK: - Tweet
extension Moments {
    
    struct Tweet: Decodable {
        
        let content: String?
        
        let images: [ImageModel]?
        
        let sender: User.Card?
        
        let comments: [Comment]?
        
        enum CodingKeys: String, CodingKey {
            case content
            case images
            case sender
            case comments
        }
    }
}

// MARK: - Comment
extension Moments {
    
    struct Comment: Decodable {
        
        let content: String?
        
        let sender: User.Card?
    }
}
