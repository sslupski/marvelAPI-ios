//
//  MvCharacterItemList.swift
//  Marvel
//
//  Created by Sebastian Slupski on 24/3/22.
//

import Foundation

struct MvCharacterItemList<T: Codable>: Codable {
    var available, returned: Int?
    var collectionURI: String?
    var items: [T]

    var count: Int {
        return items.count
    }
}
