//
//  BaseModels.swift
//  homework
//
//  Created by 刘奕成 on 2019/6/15.
//  Copyright © 2019 Eason. All rights reserved.
//

import Foundation

struct ImageModel: Decodable {
    
    let path: String?
    
    enum CodingKeys: String, CodingKey {
        case path = "url"
    }
    
    var url: URL? {
        return URL(string: path ?? "")
    }
}
