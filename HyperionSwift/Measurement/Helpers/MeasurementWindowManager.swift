//
//  MeasurementWindowManager.swift
//  HyperionSwift
//
//  Created by Matheus Gois on 01/01/25.
//

import Foundation
import UIKit

enum MeasurementWindowManager {
    static var rootNavigation: UINavigationController? {
        let navigation = window.rootViewController as? UINavigationController
        return navigation
    }

    static var presentController: CustomViewController {
        return rootNavigation!.topViewController! as! CustomViewController
    }

    static let window: MeasurementWindow = {
        let window: MeasurementWindow
        if #available(iOS 13.0, *),
           let scene = currentWindow?.windowScene {
            window = MeasurementWindow(windowScene: scene)
        } else {
            window = MeasurementWindow(frame: UIScreen.main.bounds)
        }

        let navigation = UINavigationController(rootViewController: CustomViewController())
        window.rootViewController = navigation
        window.isHidden = false

        return window
    }()

    static var currentWindow: UIWindow? {
        if #available(iOS 13.0, *) {
            return UIApplication.shared.windows.filter { $0.isKeyWindow }.first
        } else {
            return UIApplication.shared.keyWindow
        }
    }
}

final class MeasurementWindow: UIWindow {
    override var description: String {
        "MeasurementWindow is \(isHidden ? "hidden" : "visible")"
    }

    override var windowLevel: UIWindow.Level {
        get {
            .alert + 1001
        }
        set {}
    }
}

final class CustomViewController: UIViewController, PluginExtension {
    var attachedWindow: UIWindow?

    var contentView: MeasurementsView { view as! MeasurementsView }

    override func loadView() {
        super.loadView()
        view = MeasurementsView(_extension: self)
    }
}
