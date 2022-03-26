//
//  MvCharacterDetailService.swift
//  Marvel
//
//  Created by Sebastian Slupski on 20/3/22.
//

import Foundation

protocol MvCharacterDetailServiceProtocol {
    func fetchCharacter(params: MvCharacterDetailParam,
                        completion: @escaping (Result<MvCharactersModel, Error>) -> Void)
}

struct MvCharacterDetailParam: MvBaseServiceParams {
    var id: String = ""

    func queryParameters() -> [String : Any]? {
        return nil
    }
}

class MvCharacterDetailService: MvBaseService<MvCharacterDetailParam, MvCharactersModel>,
                                MvCharacterDetailServiceProtocol {

    func fetchCharacter(params: MvCharacterDetailParam,
                        completion: @escaping (Result<MvCharactersModel, Error>) -> Void) {
        let endpoint = "/v1/public/characters/\(params.id)"

        let request = MvMarvelAPI<MvCharactersModel>(endpoint: endpoint, queryParams: nil)
        request.fetchData(completion: completion)
    }
}
