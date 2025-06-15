//
//  UIWindow+.swift
//  HyperionSwift
//
//  Created by Matheus Gois on 02/01/25.
//

import UIKit

extension UIWindow {
    @MainActor
    public static var isEnable = true
    
    override open func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        super.motionEnded(motion, with: event)

        if motion == .motionShake {
            UIWindow.isEnable.toggle()
            MeasurementWindowManager.attachedWindow = UIWindow.isEnable ? UIWindow.keyWindow : nil
        }
    }

    @MainActor
    public static var keyWindow: UIWindow? {
        guard let windowScene = UIApplication.shared.connectedScenes
            .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene else {
            return nil
        }
        return windowScene.windows.first(where: { $0.isKeyWindow })
    }
}
