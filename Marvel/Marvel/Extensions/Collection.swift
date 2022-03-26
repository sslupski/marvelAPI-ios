//
//  Collection.swift
//  Marvel
//
//  Created by Sebastian Slupski on 24/3/22.
//

import Foundation

extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
