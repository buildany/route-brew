//
//  Optional.swift
//  RouteBrew
//
//  Created by km on 09/11/2022.
//

import Foundation

extension Optional where Wrapped == NSSet {
    func array<T: Hashable>(of: T.Type) -> [T] {
        if let set = self as? Set<T> {
            return Array(set)
        }
        return [T]()
    }
}
