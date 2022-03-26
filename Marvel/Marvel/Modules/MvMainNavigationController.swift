//
//  ViewController.swift
//  Marvel
//
//  Created by Sebastian Slupski on 18/3/22.
//

import UIKit

class MvMainNavigationController: UINavigationController {
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()

        let rootController = MvCharactersListViewController()
        setViewControllers([rootController], animated: true)
    }

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        let backButton = UIBarButtonItem(title: "",
                                         style: .plain,
                                         target: nil,
                                         action: nil)
        backButton.tintColor = .white
        topViewController?.navigationItem.backBarButtonItem = backButton
        super.pushViewController(viewController, animated: animated)
    }

    private func setTransparentNavigationBar() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
    }

    private func setupAppearance() {
        view.window?.overrideUserInterfaceStyle = .light
        navigationBar.barStyle = .black
    }
}

