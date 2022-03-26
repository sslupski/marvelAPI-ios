//
//  MvCharactersModel.swift
//  Marvel
//
//  Created by Sebastian Slupski on 24/3/22.
//

import Foundation

struct MvCharactersModel: MvServiceModel, Codable {
    var characters: [MvCharacterModel]?
    var offset, limit, total, count: Int?

    enum CodingKeys: String, CodingKey {
        case characters = "results"
        case offset, limit, total, count
    }
}
