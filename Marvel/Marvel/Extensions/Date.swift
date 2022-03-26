//
//  Date.swift
//  Marvel
//
//  Created by Sebastian Slupski on 24/3/22.
//

import Foundation

extension Date {
    func currentTimestamp() -> Int64 {
        return Int64(timeIntervalSince1970 * 1000)
    }
}
