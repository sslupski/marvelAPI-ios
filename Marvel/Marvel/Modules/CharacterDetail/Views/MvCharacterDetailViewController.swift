//
//  MvCharacterDetailViewController.swift
//  Marvel
//
//  Created by Sebastian Slupski on 23/3/22.
//

import UIKit

struct MvCharacterDetailModel {
    var image: String = ""
    var name: String = ""
    var description: String = ""
    var items: [String: Int]?
}

class MvCharacterDetailViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView! {
        didSet {
            imageView.contentMode = .scaleAspectFill
        }
    }
    @IBOutlet weak var descriptionLabel: UILabel!

    @IBOutlet weak var itemsStackView: UIStackView!

    var model: MvCharacterDetailModel? {
        didSet {
            guard let model = model, isViewLoaded else {
                return
            }
            bindModel(model)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if let model = model {
            bindModel(model)
        }
    }

    private func bindModel(_ model: MvCharacterDetailModel) {
        navigationItem.title = model.name
        descriptionLabel.text = model.description
        imageView.download(from: model.image) { [weak self] result in
            if case let .success(data) = result {
                self?.imageView.image = data.image
            }
        }

        if let items = model.items {
            setItems(items)
        }
    }

    private func setItems(_ items: [String: Int]) {
        items.forEach { item in
            let title = item.key
            let description = item.value.description
            if let view = MvCharacterDetailItemView.create(title: title,
                                                           description: description) {
                itemsStackView.addArrangedSubview(view)
            }
        }
    }
}
