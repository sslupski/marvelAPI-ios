//
//  MvCharactersListViewModelMocks.swift
//  MarvelTests
//
//  Created by Sebastian Slupski on 26/3/22.
//

import Foundation
@testable import Marvel

extension MvCharactersListViewModelTests {
    class MvCharactersServiceMock: MvCharactersServiceProtocol {
        private var maxItems = 15
        private var itemsByPage = 10

        var fail = false
        var noResults = false

        private func getModel(page: Int) -> MvCharactersModel {
            guard !noResults else { return getNoResultsModel() }
            let items = (page + 1) * itemsByPage <= maxItems ? itemsByPage : (maxItems - itemsByPage)
            let offset = page * itemsByPage
            var characters = [MvCharacterModel]()
            for i in 1...items {
                characters.append(MvCharacterModel(id: offset + i - 1, name: "Character \(offset + i - 1)"))
            }

            return MvCharactersModel(characters: characters,
                                     offset: offset,
                                     limit: itemsByPage,
                                     total: maxItems,
                                     count: items)
        }

        private func getNoResultsModel() -> MvCharactersModel {
            return MvCharactersModel(characters: [],
                                     offset: 0,
                                     limit: itemsByPage,
                                     total: 0,
                                     count: 0)
        }

        func fetchCharacters(params: MvCharactersParams, completion: @escaping (Result<MvCharactersModel, Error>) -> Void) {
            guard !fail else {
                completion(.failure(NSError()))
                return
            }

            let model = getModel(page: params.page)
            completion(.success(model))
        }

        func clean() {
            fail = false
            noResults = false
        }
    }
}

extension MvCharactersListViewModelTests {
    class MvCharactersListViewMock: MvCharactersListViewProtocol {
        var errorShowed = false
        var characterDetail: MvCharacterDetailModel?
        var listReloaded = false

        func reloadCharacters() {
            listReloaded = true
            errorShowed = false
        }

        func showError() {
            errorShowed = true
        }

        func showDetail(model: MvCharacterDetailModel) {
            characterDetail = model
        }

        func clean() {
            errorShowed = false
            characterDetail = nil
            listReloaded = false
        }
    }
}
