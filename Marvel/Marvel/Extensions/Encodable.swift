//
//  Encodable.swift
//  Marvel
//
//  Created by Sebastian Slupski on 20/3/22.
//

import Foundation

extension Encodable {
    func asDictionary() -> [String: Any]? {
        do {
            let data = try JSONEncoder().encode(self)
            guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
                throw NSError()
            }
            return dictionary
        } catch {
            return nil
        }
    }
}
