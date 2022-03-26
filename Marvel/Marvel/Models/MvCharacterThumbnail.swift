//
//  MvCharacterThumbnail.swift
//  Marvel
//
//  Created by Sebastian Slupski on 24/3/22.
//

import Foundation

struct MvCharacterThumbnail: Codable {
    var path, imageExtension: String?
    var urlString: String? {
        guard let path = path, let ext = imageExtension else { return nil }
        return "\(path).\(ext)"
    }

    enum CodingKeys: String, CodingKey {
        case imageExtension = "extension"
        case path
    }
}
