//
//  TypeToString.swift
//  adventure
//
//  Created by Mike Budei on 8/6/19.
//  Copyright © 2019 Mike Budei. All rights reserved.
//

import Foundation

protocol TypeToStringProtocol: NSObjectProtocol {
    static var name: String { get }
}

extension TypeToStringProtocol {
    static var name: String {
        return String(describing: self)
    }
}
