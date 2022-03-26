//
//  MvIndicatorCollectionViewCell.swift
//  Marvel
//
//  Created by Sebastian Slupski on 20/3/22.
//

import UIKit

class MvIndicatorCollectionViewCell: UICollectionReusableView {
    var indicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.style = .large
        view.color = .white
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    func setup(){
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
        addSubview(indicator)
        NSLayoutConstraint.activate([
            indicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
        indicator.startAnimating()
    }
}
