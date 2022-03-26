//
//  MvCharactersListViewController.swift
//  Marvel
//
//  Created by Sebastian Slupski on 19/3/22.
//

import UIKit

protocol MvCharactersListViewProtocol: AnyObject {
    func reloadCharacters()
    func showError()

    func showDetail(model: MvCharacterDetailModel)
}

class MvCharactersListViewController: UIViewController {
    private let itemsByRow: CGFloat = 1
    private let sideInset: CGFloat = 0
    private let columnSpacing: CGFloat = 0
    private let rowSpacing: CGFloat = 1
    private let itemHeight: CGFloat = 300

    init(viewModel: MvCharactersListViewModelDelegate? = nil) {
        super.init(nibName: nil, bundle: nil)
        let viewModel = viewModel ?? MvCharactersListViewModel()
        self.viewModel = viewModel
        viewModel.attachView(view: self)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var viewModel: MvCharactersListViewModelDelegate?

    @IBOutlet private weak var charactersCollectionView: UICollectionView! {
        didSet {
            charactersCollectionView.backgroundColor = .black
            charactersCollectionView.delegate = self
            charactersCollectionView.dataSource = self

            setCollectionLayout()

            charactersCollectionView.register(MvCharacterListViewCell.self)
            charactersCollectionView.registerSupplementaryClass(MvIndicatorCollectionViewCell.self,
                                                           kind: UICollectionView.elementKindSectionFooter)
            charactersCollectionView.registerSupplementaryClass(MvCharactersListErrorReusableView.self,
                                                                kind: UICollectionView.elementKindSectionFooter)
            charactersCollectionView.registerSupplementaryClass(MvCharactersListNoResultReusableView.self,
                                                                kind: UICollectionView.elementKindSectionFooter)
        }
    }

    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Marvel characters"
        searchController.searchBar.delegate = self
        return searchController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    private func setup() {
        navigationItem.title = viewModel?.navTitle
        view.backgroundColor = .black

        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false

        definesPresentationContext = true
    }

    private func setCollectionLayout() {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0,
                                           left: sideInset,
                                           bottom: 0,
                                           right: sideInset)
        layout.minimumLineSpacing = rowSpacing
        layout.minimumInteritemSpacing = columnSpacing
        let totalWidth = UIScreen.main.bounds.size.width - (sideInset * 2) - columnSpacing
        layout.itemSize = CGSize(width: totalWidth / itemsByRow,
                                 height: itemHeight)
        charactersCollectionView.collectionViewLayout = layout
    }

    private func showMoreLoading() {
        charactersCollectionView.collectionViewLayout.invalidateLayout(with: UICollectionViewFlowLayoutInvalidationContext())
    }

    private func hideMoreLoading() {
        guard let state = viewModel?.state else {
            return
        }

        if state == .noResults || state == .error {
            charactersCollectionView.collectionViewLayout.invalidateLayout(with: UICollectionViewFlowLayoutInvalidationContext())
            if state == .error {
                charactersCollectionView.reloadSections([0])
            }
        }
    }

    private func getCharacterCell(_ collectionView: UICollectionView,
                                  indexPath: IndexPath) -> UICollectionViewCell {
        guard let character = viewModel?.character(at: indexPath.item),
              let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MvCharacterListViewCell.reuseIdentifier, for: indexPath) as? MvCharacterListViewCellProtocol
        else {
            return UICollectionViewCell()
        }
        cell.model = character
        return cell
    }
}

extension MvCharactersListViewController: MvCharactersListViewProtocol {
    func reloadCharacters() {
        DispatchQueue.main.async {
            self.hideMoreLoading()
            self.charactersCollectionView.reloadSections([0])
        }
    }

    func showError() {
        DispatchQueue.main.async {
            self.hideMoreLoading()
        }
    }

    func showDetail(model: MvCharacterDetailModel) {
        let view = MvCharacterDetailViewController()
        view.model = model
        navigationController?.pushViewController(view, animated: true)
    }
}

extension MvCharactersListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter,
           let state = viewModel?.state,
           let identifier = state.cellIdentifier {
            let footer = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: identifier,
                for: indexPath
            )

            if let errorFooter = footer as? MvCharactersListErrorReusableView {
                errorFooter.delegate = self
            }

            return footer
        }
        return UICollectionReusableView()
    }

    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        viewModel?.didSelect(character: indexPath.item)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let viewModel = viewModel else { return }
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        if viewModel.canLoadMore(),
           offsetY > contentHeight - scrollView.frame.size.height {
            showMoreLoading()
            
            let name = searchController.searchBar.text ?? ""
            viewModel.loadNextPage(name: name)
        }
    }
}

extension MvCharactersListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return viewModel?.charactersCount ?? 0
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return getCharacterCell(collectionView, indexPath: indexPath)
    }
}

extension MvCharactersListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForFooterInSection section: Int) -> CGSize {
        let customHeight: CGFloat = 300
        let height = (viewModel?.charactersCount ?? 0 > 0) ? customHeight : collectionView.frame.size.height
        return shouldShowFooter() ? CGSize(width: UIScreen.main.bounds.size.width, height: height) : CGSize.zero
    }

    private func shouldShowFooter() -> Bool {
        return viewModel?.state != .success
    }
}

extension MvCharactersListViewController: MvErrorViewDelegate {
    func tryAgain() {
        viewModel?.retry()
        charactersCollectionView.reloadSections([0])
    }
}

extension MvCharactersListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else {
            return
        }
        viewModel?.loadNextPage(name: text)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel?.loadNextPage(name: "")
    }
}

extension MvCharactersListViewModel.State {
    var cellIdentifier: String? {
        var identifier: String?
        switch self {
        case .loading:
            identifier = MvIndicatorCollectionViewCell.reuseIdentifier

        case .error:
            identifier = MvCharactersListErrorReusableView.reuseIdentifier

        case .noResults:
            identifier = MvCharactersListNoResultReusableView.reuseIdentifier

        default:
            identifier = nil
        }

        return identifier
    }
}
