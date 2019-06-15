//
//  NSObject+Rx.swift
//  homework
//
//  Created by 刘奕成 on 2019/6/15.
//  Copyright © 2019 Eason. All rights reserved.
//

import RxSwift
import RxCocoa

fileprivate struct AssociatedKeys {
    static var dsbag = "NSObject.rx.dsbag"
}

#if DEBUG
fileprivate let GlobalBag = DisposeBag()
#endif

extension Reactive where Base: NSObject {
    
    var dsbag: DisposeBag {
        get {
            if let bag = objc_getAssociatedObject(base, &AssociatedKeys.dsbag) as? DisposeBag {
                return bag
            }
            
            let bag = DisposeBag()
            
            #if DEBUG
            deallocating.subscribeNext(on: {
                print("\(Base.self) deinit...")
            }).disposed(by: GlobalBag)
            #endif
            
            objc_setAssociatedObject(base, &AssociatedKeys.dsbag, bag, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            
            return bag
        }
    }
}
