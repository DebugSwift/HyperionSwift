//
//  HyperionSwiftApp.swift
//  HyperionSwift
//
//  Created by Matheus Gois on 01/01/25.
//

import SwiftUI

@available(iOS 14.0, *)
@main
struct Example_SwiftUIApp: App {
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
