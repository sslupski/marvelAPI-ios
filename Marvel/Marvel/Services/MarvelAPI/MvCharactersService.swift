//
//  MvCharactersService.swift
//  Marvel
//
//  Created by Sebastian Slupski on 20/3/22.
//

import Foundation

protocol MvCharactersServiceProtocol {
    func fetchCharacters(params: MvCharactersParams,
                         completion: @escaping (Result<MvCharactersModel, Error>) -> Void)
}

struct MvCharactersParams: MvBaseServiceParams {
    private let limit: Int = 20
    private var offset: Int {
        return page * limit
    }

    var name: String?
    var page: Int = 0

    func queryParameters() -> [String : Any]? {
        var params = [String: Any]()
        params.updateValue(limit, forKey: "limit")
        params.updateValue(offset, forKey: "offset")

        if let name = name?.trimmingCharacters(in: .whitespacesAndNewlines), !name.isEmpty {
            params.updateValue(name, forKey: "nameStartsWith")
        }
        return params
    }
}

class MvCharactersService: MvBaseService<MvCharactersParams, MvCharactersModel>,
                           MvCharactersServiceProtocol {
    func fetchCharacters(params: MvCharactersParams,
                         completion: @escaping (Result<MvCharactersModel, Error>) -> Void) {
        let endpoint = "/v1/public/characters"
        let params = params.queryParameters()

        let request = MvMarvelAPI<MvCharactersModel>(endpoint: endpoint, queryParams: params)
        request.fetchData(completion: completion)
    }
}
