//
//  MvCharacterItem.swift
//  Marvel
//
//  Created by Sebastian Slupski on 24/3/22.
//

import Foundation

protocol MvCharacterItem: Codable {
    var name: String? { get set }
    var resourceURI: String? { get set }
}

struct MvCharacterComic: MvCharacterItem {
    var name, resourceURI: String?
}

struct MvCharacterStory: MvCharacterItem {
    var name, resourceURI: String?
    var type: String?
}

struct MvCharacterEvent: MvCharacterItem {
    var name, resourceURI: String?
}

struct MvCharacterSeries: MvCharacterItem {
    var name, resourceURI: String?
}
