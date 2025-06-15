//
//  MeasurementWindowManager.swift
//  HyperionSwift
//
//  Created by Matheus Gois on 01/01/25.
//

import Foundation
import UIKit

@MainActor
public enum MeasurementWindowManager {
    public static var attachedWindow: UIWindow? {
        didSet {
            presentController.attachedWindow = attachedWindow
            let isEnabled = attachedWindow != nil

            window.isHidden = !isEnabled
        }
    }

    static var currentWindow: UIWindow? {
        guard let windowScene = UIApplication.shared.connectedScenes
            .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene else {
            return nil
        }
        return windowScene.windows.first(where: { $0.isKeyWindow })
    }

    private static var rootNavigation: UINavigationController? {
        let navigation = window.rootViewController as? UINavigationController
        return navigation
    }

    private static var presentController: CustomViewController {
        return rootNavigation!.topViewController! as! CustomViewController
    }

    private static let window: MeasurementWindow = {
        let window: MeasurementWindow
        
        if let scene = currentWindow?.windowScene {
            window = MeasurementWindow(windowScene: scene)
        } else {
            window = MeasurementWindow(frame: UIScreen.main.bounds)
        }

        let navigation = UINavigationController(rootViewController: CustomViewController())
        window.rootViewController = navigation
        window.isHidden = false

        return window
    }()
}

@MainActor
final class MeasurementWindow: UIWindow {
    override var description: String {
        MainActor.assumeIsolated {
            "MeasurementWindow is \(isHidden ? "hidden" : "visible")"
        }
    }

    override var windowLevel: UIWindow.Level {
        get {
            .alert + 1001
        }
        set {}
    }
}

@MainActor
final class CustomViewController: UIViewController, MeasurementViewDelegate {
    var attachedWindow: UIWindow? {
        didSet {
            if attachedWindow != nil {
                view = MeasurementsView(delegate: self)
            }
        }
    }

    var contentView: MeasurementsView { view as! MeasurementsView }

    override func loadView() {
        super.loadView()
        view = MeasurementsView(delegate: self)
    }
}
