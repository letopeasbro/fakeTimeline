//
//  Network.swift
//  homework
//
//  Created by 刘奕成 on 2019/6/16.
//  Copyright © 2019 Eason. All rights reserved.
//

import Alamofire

struct Network {
    
    // MARK: ReachabilityStatus
    
    typealias ReachabilityStatus = NetworkReachabilityManager.NetworkReachabilityStatus
    
    static let reachabilityStatus: Observable<ReachabilityStatus> = {
        return Observable<ReachabilityStatus>.create({ (observer) -> Disposable in
            guard let manager = NetworkReachabilityManager() ?? NetworkReachabilityManager(host: "http://wwww.baidu.com") else {
                observer.onCompleted()
                return Disposables.create()
            }
            manager.listener = { [unowned manager] _ in
                observer.onNext(manager.networkReachabilityStatus)
            }
            manager.startListening()
            return Disposables.create {
                let _ = manager
            }
        }).share()
    }()
    
    typealias ConnectionType = NetworkReachabilityManager.ConnectionType
    
    static let reachable: Observable<ConnectionType> = {
        return reachabilityStatus.filter({
            guard case .reachable = $0 else { return false }
            return true
        }).map({
            guard case .reachable(let type) = $0 else { fatalError() }
            return type
        })
    }()
}
