//
//  UITableView+EasyReuse.swift
//  homework
//
//  Created by 刘奕成 on 2019/6/15.
//  Copyright © 2019 Eason. All rights reserved.
//

import UIKit

extension UITableView {
    
    public func register<T: UITableViewCell>(_ cellClass: T.Type) {
        register(cellClass, forCellReuseIdentifier: "\(T.self)")
    }
    
    public func register<T: UITableViewHeaderFooterView>(headerFooterView viewClass: T.Type) {
        register(viewClass, forHeaderFooterViewReuseIdentifier: "\(T.self)")
    }
    
    public func dequeueReusableCell<T: UITableViewCell>() -> T {
        let identifer = "\(T.self)"
        if let cell = dequeueReusableCell(withIdentifier: identifer) as? T {
            return cell
        } else {
            return T.init(style: .default, reuseIdentifier: identifer)
        }
    }
    
    public func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>() -> T {
        let identifer = "\(T.self)"
        if let view = dequeueReusableHeaderFooterView(withIdentifier: identifer) as? T {
            return view
        } else {
            return T.init(reuseIdentifier: identifer)
        }
    }
}
