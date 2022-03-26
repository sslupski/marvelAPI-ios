//
//  MvCharactersListNoResultReusableView.swift
//  Marvel
//
//  Created by Sebastian Slupski on 26/3/22.
//

import UIKit

class MvCharactersListNoResultReusableView: UICollectionReusableView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup(){
        guard let image = UIImage(named: "spiderConfused") else { return }
        let errorModel = MvErrorViewModel(image: image,
                                          text: """
                                          Sorry, we couldn't find anyone with that name.
                                          Try another!
                                          """,
                                          buttonText: nil,
                                          delegate: nil)

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
