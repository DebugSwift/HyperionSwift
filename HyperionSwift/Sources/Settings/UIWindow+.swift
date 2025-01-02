//
//  UIWindow+.swift
//  HyperionSwift
//
//  Created by Matheus Gois on 02/01/25.
//

import Foundation

extension UIWindow {
    public static var isEnable = true
    override open func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        super.motionEnded(motion, with: event)

        if motion == .motionShake {
            UIWindow.isEnable.toggle()
            MeasurementWindowManager.attachedWindow = UIWindow.isEnable ? UIWindow.keyWindow : nil
        }
    }

    public static var keyWindow: UIWindow? {
        return UIApplication.shared.windows.first
    }
}
