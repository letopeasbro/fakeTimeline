//
//  Observable+Conveniences.swift
//  homework
//
//  Created by 刘奕成 on 2019/6/15.
//  Copyright © 2019 Eason. All rights reserved.
//

import RxSwift

extension ObservableType {
    
    func doNext(on next: ((Self.E) throws -> Swift.Void)?) -> Observable<E> {
        return `do`(onNext: next)
    }
    
    func subscribeNext(on next: ((E) -> Swift.Void)?) -> Disposable {
        return subscribe(onNext: next)
    }
}
