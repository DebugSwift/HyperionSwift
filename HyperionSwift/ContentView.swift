//
//  ContentView.swift
//  HyperionSwift
//
//  Created by Matheus Gois on 01/01/25.
//

import SwiftUI

struct ContentView: View {

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
            MeasurementWindowManager.attachedWindow = UIWindow.keyWindow
        }
    }

}

extension UIWindow {
    static var isEnable = true
    open override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        super.motionEnded(motion, with: event)

        if motion == .motionShake {
            UIWindow.isEnable.toggle()
            MeasurementWindowManager.attachedWindow = UIWindow.isEnable ? UIWindow.keyWindow : nil
        }
    }

    static var keyWindow: UIWindow? {
        return UIApplication.shared.windows.first
    }
}

#Preview {
    ContentView()
}
