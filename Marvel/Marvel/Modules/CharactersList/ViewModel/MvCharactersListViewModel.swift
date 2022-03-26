//
//  MvCharactersListViewModel.swift
//  Marvel
//
//  Created by Sebastian Slupski on 19/3/22.
//

import Foundation

protocol MvCharactersListViewModelDelegate {
    var navTitle: String { get }
    func attachView(view: MvCharactersListViewProtocol)

    var state: MvCharactersListViewModel.State { get }
    func loadNextPage(name: String)
    func canLoadMore() -> Bool
    func retry()

    var charactersCount: Int { get }
    func character(at position: Int) -> MvCharacterListViewCellModel?
    func didSelect(character at: Int)
}

class MvCharactersListViewModel {
    enum State {
        case success
        case loading
        case error
        case noResults
    }

    init(charactersService: MvCharactersServiceProtocol? = nil) {
        self.charactersService = charactersService ?? MvCharactersService()
    }

    private weak var view: MvCharactersListViewProtocol?

    private let charactersService: MvCharactersServiceProtocol?

    private var charactersModel: MvCharactersModel?
    private var characters: [MvCharacterModel] = []
    private var currentPage: Int  = -1
    private var currentName = ""

    private var isLoading = false
    private var isError = false

    var state: State {
        var currentState: State = .success

        if isLoading {
            currentState = .loading
        } else if isError {
            currentState = .error
        } else if charactersCount == 0 {
            currentState = .noResults
        }

        return currentState
    }

    var navTitle: String = "Marvel"
    var charactersCount: Int {
        return characters.count
    }

    private func resetSearch() {
        charactersModel = nil
        characters = []
        currentPage = -1
        isLoading = false
        isError = false
        view?.reloadCharacters()
    }

    private func setCharacters(model: MvCharactersModel) {
        charactersModel = model

        if currentPage < 0 {
            characters = model.characters ?? []
        } else {
            characters += model.characters ?? []
        }

        currentPage += 1
        view?.reloadCharacters()
    }

    private func fetchCharacters(params: MvCharactersParams, completion: @escaping (Result<MvCharactersModel, Error>) -> Void) {
        isLoading = true
        isError = false
        charactersService?.fetchCharacters(params: params) { [weak self] result in
            self?.isLoading = false
            completion(result)
        }
    }

    private func getItems(_ character: MvCharacterModel) -> [String: Int] {
        return character.getItemsTotalList()
    }
}

extension MvCharactersListViewModel: MvCharactersListViewModelDelegate {
    func attachView(view: MvCharactersListViewProtocol) {
        self.view = view
    }

    func canLoadMore() -> Bool {
        return characters.count < charactersModel?.total ?? Int.max && !isLoading && !isError
    }

    func loadNextPage(name: String) {
        if name != currentName {
            resetSearch()
            currentName = name
        }

        guard canLoadMore() else { return }
        let params = MvCharactersParams(name: name, page: currentPage + 1)
        fetchCharacters(params: params) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let model):
                self.setCharacters(model: model)

            case .failure:
                self.isError = true
                self.view?.showError()
            }
        }
    }

    func retry() {
        isError = false
        isLoading = false
        loadNextPage(name: currentName)
    }

    func character(at position: Int) -> MvCharacterListViewCellModel? {
        guard let character = characters[safe: position] else { return nil }
        let cellModel = MvCharacterListViewCellModel(
            name: character.name ?? "",
            description: character.description ?? "",
            imageUrl: character.thumbnail?.urlString ?? ""
        )
        return cellModel
    }

    func didSelect(character at: Int) {
        guard let character = characters[safe: at] else { return }
        let model = MvCharacterDetailModel(
            image: character.thumbnail?.urlString ?? "",
            name: character.name ?? "",
            description: character.description ?? "",
            items: getItems(character)
        )
        view?.showDetail(model: model)
    }
}
