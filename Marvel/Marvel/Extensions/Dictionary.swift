//
//  Dictionary.swift
//  Marvel
//
//  Created by Sebastian Slupski on 24/3/22.
//

import Foundation

extension Dictionary {
    func httpParams() -> [URLQueryItem] {
        return map({ URLQueryItem(name: "\($0.key)", value: "\($0.value)") })
    }
}
