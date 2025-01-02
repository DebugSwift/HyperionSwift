//
//  OverlayWindowManager.swift
//  HyperionSwift
//
//  Created by Matheus Gois on 01/01/25.
//

import Foundation
import SwiftUI

import UIKit

enum WindowManager {
    static var isSelectingWindow = false
    static var rootNavigation: UINavigationController? {
        let navigation = window.rootViewController as? UINavigationController
        return navigation
    }

    static var presentController: CustomViewController {
        return rootNavigation!.topViewController! as! CustomViewController
    }

    static let window: CustomWindow = {
        let window: CustomWindow
        if #available(iOS 13.0, *),
           let scene = UIApplication.shared.keyWindow?.windowScene {
            window = CustomWindow(windowScene: scene)
        } else {
            window = CustomWindow(frame: UIScreen.main.bounds)
        }
        window.windowLevel = .alert + 1

        let navigation = UINavigationController(rootViewController: CustomViewController())

        window.rootViewController = navigation
        window.isHidden = false
        return window
    }()
}

final class CustomWindow: UIWindow {}

final class CustomViewController: UIViewController, PluginExtension {
    var attachedWindow: UIWindow?

    var contentView: MeasurementsInteractionView { view as! MeasurementsInteractionView }

    override func loadView() {
        super.loadView()
        view = MeasurementsInteractionView(_extension: self)
    }
}
