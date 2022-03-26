//
//  MvCharacterDetailItemView.swift
//  Marvel
//
//  Created by Sebastian Slupski on 23/3/22.
//

import UIKit

class MvCharacterDetailItemView: UIView {
    static func create(title: String, description: String) -> MvCharacterDetailItemView? {
        let viewName = String(describing: self)
        guard let nib = Bundle.main.loadNibNamed(viewName, owner: self, options: nil),
              let view = nib.first as? MvCharacterDetailItemView else {
                  return nil
              }
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setContentCompressionResistancePriority(.required, for: .vertical)
        view.setContentHuggingPriority(.required, for: .vertical)
        view.itemTitle.text = title
        view.itemDescription.text = description
        return view
    }

    @IBOutlet weak var itemTitle: UILabel!

    @IBOutlet weak var itemDescription: UILabel!
}
