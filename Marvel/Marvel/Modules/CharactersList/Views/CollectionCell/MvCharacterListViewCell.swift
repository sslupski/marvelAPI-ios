//
//  MvCharacterListViewCell.swift
//  Marvel
//
//  Created by Sebastian Slupski on 19/3/22.
//

import UIKit

struct MvCharacterListViewCellModel {
    var name: String
    var description: String
    var imageUrl: String
}

protocol MvCharacterListViewCellProtocol: UICollectionViewCell {
    var model: MvCharacterListViewCellModel? { get set }
}

class MvCharacterListViewCell: UICollectionViewCell, MvCharacterListViewCellProtocol {
    private var dataTask: URLSessionDataTask?
    private var imageUrl: String?
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView! {
        didSet {
            imageView.contentMode = .scaleAspectFill
        }
    }

    var model: MvCharacterListViewCellModel? {
        didSet {
            setModel()
        }
    }

    private func setModel() {
        guard let model = model else { return }
        titleLabel.text = model.name
        descriptionLabel.text = model.description
        imageUrl = model.imageUrl
        let dataTask = imageView.download(from: model.imageUrl) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let networkResult):
                self.setNetworkImage(responseUrl: networkResult.responseUrl, image: networkResult.image)
            default:
                self.imageView.image = nil
            }
        }
        self.dataTask = dataTask
    }

    private func setNetworkImage(responseUrl: String?, image: UIImage?) {
        if let image = image,
           let originalUrl = imageUrl,
           originalUrl == responseUrl{
            imageView.image = image
        } else {
            imageView.image = nil
        }
    }

    override func prepareForReuse() {
        titleLabel.text = ""
        descriptionLabel.text = ""
        imageView.image = nil
        dataTask?.cancel()
        dataTask = nil
    }
}
