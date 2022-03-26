//
//  UICollectionView.swift
//  Marvel
//
//  Created by Sebastian Slupski on 19/3/22.
//

import UIKit

extension UICollectionView {
    func register<T: UICollectionViewCell>(_ type: T.Type, bundle: Bundle? = nil) {
        register(UINib(nibName: type.reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: type.reuseIdentifier)
    }

    func registerSupplementaryClass<T: UICollectionReusableView>(_ type: T.Type, kind: String, bundle: Bundle? = nil) {
        register(type, forSupplementaryViewOfKind: kind, withReuseIdentifier: type.reuseIdentifier)
    }
}

extension UICollectionReusableView {
    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
}
