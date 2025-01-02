//
//  HyperionSwift.swift
//  HyperionSwift
//
//  Created by Matheus Gois on 02/01/25.
//

import UIKit

class HyperionSwift {

    private init() {}
    static let shared = HyperionSwift()

    private lazy var menu = MenuViewController(delegate: self)
    private lazy var menuPresenter: SideMenuPresenting = SideMenuPresenter(
        menuViewControllerFactory: menu
    )

    func setup() {
        if let controller = topViewControoler() {
            setup(in: controller)
        }
    }

    func present() {
        if let controller = topViewControoler() {
            present(from: controller)
        }
    }

    func setup(in controller: UIViewController) {
        menuPresenter.setup(in: controller)
    }

    func present(from controller: UIViewController) {
        menuPresenter.present(from: controller)
    }

    func topViewControoler() -> UIViewController? {
        UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.rootViewController
    }
}

extension HyperionSwift: MenuDelegate {
    func didSelectMenuItem(_ menuItem: MenuItem) {
        switch menuItem {
        case .measurement:
            activateMeasurement()
        }
    }

    private func activateMeasurement() {
        menu.dismiss(animated: true)
        UIWindow.isEnable = true
        MeasurementWindowManager.attachedWindow = UIWindow.keyWindow
    }
}
