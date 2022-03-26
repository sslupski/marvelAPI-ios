//
//  MvCharacterModel.swift
//  Marvel
//
//  Created by Sebastian Slupski on 24/3/22.
//

import Foundation

struct MvCharacterModel: Codable {
    var id: Int?
    var name, description, resourceURI: String?
    var urls: [MvCharacterUrl]?
    var thumbnail: MvCharacterThumbnail?
    var comics: MvCharacterItemList<MvCharacterComic>?
    var stories: MvCharacterItemList<MvCharacterStory>?
    var events: MvCharacterItemList<MvCharacterEvent>?
    var series: MvCharacterItemList<MvCharacterSeries>?

    enum Item: String, CaseIterable {
        case comics
        case stories
        case events
        case series
    }

    func getItemsTotalList() -> [String: Int] {
        return Item.allCases.reduce(into: [String: Int]()) {
            $0[$1.rawValue.capitalized] = getItemTotal(item: $1)
        }
    }

    func getItemTotal(item: Item) -> Int? {
        var items: Int?
        switch item {
        case .comics:
            items = comics?.available
        case .stories:
            items = stories?.available
        case .events:
            items = events?.available
        case .series:
            items = series?.available
        }
        return items
    }
}
