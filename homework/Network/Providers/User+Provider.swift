//
//  User+Provider.swift
//  homework
//
//  Created by 刘奕成 on 2019/6/15.
//  Copyright © 2019 Eason. All rights reserved.
//

import Moya

// MARK: - API
extension User {
    
    enum API: Moya.TargetType {
        
        case profile
        
        var baseURL: URL {
            return APIController.hostURL
        }
        
        var path: String {
            switch self {
            case .profile:
                return "user/jsmith"
            }
        }
        
        var method: Moya.Method {
            switch self {
            case .profile:
                return .get
            }
        }
        
        var sampleData: Data {
            // 使用Charles调试
            return Data()
        }
        
        var task: Task {
            switch self {
            case .profile:
                return .requestPlain
            }
        }
        
        var headers: [String : String]? {
            return nil
        }
    }
}

// MARK: - Provider
extension User {
    
    static let provider = Moya.MoyaProvider<API>()
}
