//
//  MvCharactersListErrorReusableView.swift
//  Marvel
//
//  Created by Sebastian Slupski on 23/3/22.
//

import UIKit

class MvCharactersListErrorReusableView: UICollectionReusableView {
    var delegate: MvErrorViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup(){
        guard let image = UIImage(named: "hulkError") else { return }
        let errorModel = MvErrorViewModel(image: image, delegate: self)

        guard let errorView = MvErrorView.create(model: errorModel) else { return }
        backgroundColor = .clear
        addSubview(errorView)
        NSLayoutConstraint.activate([
            errorView.widthAnchor.constraint(equalTo: widthAnchor),
            errorView.heightAnchor.constraint(equalTo: heightAnchor),
            errorView.centerXAnchor.constraint(equalTo: centerXAnchor),
            errorView.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
}

extension MvCharactersListErrorReusableView: MvErrorViewDelegate {
    func tryAgain() {
        delegate?.tryAgain()
    }
}
