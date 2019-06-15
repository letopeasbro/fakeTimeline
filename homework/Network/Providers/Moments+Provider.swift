//
//  Moments+Provider.swift
//  homework
//
//  Created by 刘奕成 on 2019/6/15.
//  Copyright © 2019 Eason. All rights reserved.
//

import Moya

// MARK: - API
extension Moments {
    
    enum API: Moya.TargetType {
        case tweets
        
        var baseURL: URL {
            return APIController.hostURL
        }
        
        var path: String {
            switch self {
            case .tweets:
                return "user/jsmith/tweets"
            }
        }
        
        var method: Moya.Method {
            switch self {
            case .tweets:
                return .get
            }
        }
        
        var sampleData: Data {
            return Data()
        }
        
        var task: Task {
            switch self {
            case .tweets:
                return .requestPlain
            }
        }
        
        var headers: [String : String]? {
            return nil
        }
    }
}

// MARK: - Provider
extension Moments {
    
    private static let requestClosure = { (endpoint: Endpoint, done: MoyaProvider.RequestResultClosure) in
        do {
            var request = try endpoint.urlRequest()
            request.timeoutInterval = 10.0
            done(.success(request))
        } catch {
            done(.failure(MoyaError.underlying(error, nil)))
        }
    }
    
    static let callbackQueue = DispatchQueue(label: "Moments.provider.callbackQueue")
    
    static let provider = Moya.MoyaProvider<API>.init(requestClosure: requestClosure, callbackQueue: callbackQueue)
}
