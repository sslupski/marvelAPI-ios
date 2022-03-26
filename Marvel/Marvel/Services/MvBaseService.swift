//
//  MvBaseService.swift
//  Marvel
//
//  Created by Sebastian Slupski on 20/3/22.
//

import Foundation

protocol MvBaseServiceParams {
    func queryParameters() -> [String: Any]?
}

protocol MvServiceModel: Codable { }

class MvBaseService<P: MvBaseServiceParams, T: MvServiceModel> {

}
