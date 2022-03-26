//
//  MvErrorView.swift
//  Marvel
//
//  Created by Sebastian Slupski on 23/3/22.
//

import UIKit

struct MvErrorViewModel {
    var image: UIImage
    var text: String? = "Ups, something went wrong"
    var buttonText: String? = "Try again"
    var delegate: MvErrorViewDelegate?
}

protocol MvErrorViewDelegate: AnyObject {
    func tryAgain()
}

class MvErrorView: UIView {
    private weak var delegate: MvErrorViewDelegate?

    @IBOutlet private weak var stackView: UIStackView!

    @IBOutlet private weak var imageView: UIImageView! {
        didSet {
            imageView.contentMode = .scaleAspectFit
        }
    }
    @IBOutlet private weak var tryAgainButton: UIButton!
    @IBOutlet private weak var infoLabel: UILabel!

    static func create(model: MvErrorViewModel) -> MvErrorView? {
        let viewName = String(describing: self)
        guard let nib = Bundle.main.loadNibNamed(viewName, owner: self, options: nil),
              let view = nib.first as? MvErrorView else {
                  return nil
              }
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setContentCompressionResistancePriority(.required, for: .vertical)
        view.setContentHuggingPriority(.required, for: .vertical)

        view.setupModel(model: model)
        return view
    }

    private func setupModel(model: MvErrorViewModel) {
        imageView.image = model.image
        delegate = model.delegate

        if let text = model.text {
            infoLabel.text = text
        } else {
            infoLabel.isHidden = true
        }

        if let buttonText = model.buttonText {
            tryAgainButton.setTitle(buttonText, for: .normal)
        } else {
            tryAgainButton.isHidden = true
        }
    }

    @IBAction private func tryAgain(_ sender: AnyObject?) {
        delegate?.tryAgain()
    }
}
