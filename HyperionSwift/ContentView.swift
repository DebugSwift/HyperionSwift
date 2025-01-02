//
//  ContentView.swift
//  HyperionSwift
//
//  Created by Matheus Gois on 01/01/25.
//

import SwiftUI

struct ContentView: View {
    let plugin = PluginExtensionWindow()

    var body: some View {
        VStack {
            HStack {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .font(.largeTitle)
                    .padding()
                    .padding()

                Image(systemName: "globe")
                    .imageScale(.large)
                    .font(.largeTitle)
                    .padding()
                    .padding()
            }

            Text("Hello, world!")
                .font(.largeTitle)
        }
        .padding()
        .onAppear {
            if let topViewController = getTopViewController() {
                print("Top View Controller: \(topViewController)")

                let controller = MeasurementWindowManager.presentController
                controller.attachedWindow = topViewController.view.window
            }
        }
    }

    func getTopViewController() -> UIViewController? {
        var topController: UIViewController? = UIApplication.shared.windows.first { $0.isKeyWindow }?.rootViewController

        while let presentedViewController = topController?.presentedViewController {
            topController = presentedViewController
        }

        return topController
    }
}

class PluginExtensionWindow: PluginExtension {
    var attachedWindow: UIWindow? = UIApplication.shared.windows.first { $0.isKeyWindow }
}

#Preview {
    ContentView()
}
