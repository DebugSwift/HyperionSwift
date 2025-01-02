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
            Rectangle()
                .fill(Color.gray.opacity(0.2))
                .frame(height: 100)
                .overlay(
                    HStack {
                        Spacer()
                        Image(systemName: "globe")
                            .imageScale(.large)
                            .font(.largeTitle)
                            .padding(0)

                        Spacer(minLength: 80)

                        Image(systemName: "globe")
                            .imageScale(.large)
                            .font(.largeTitle)
                            .padding(0)

                        Spacer()
                    }
                )

            Text("Hello, world!")
                .font(.largeTitle)
        }
        .padding()
        .onAppear {
            if let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) {
                MeasurementWindowManager.attachedWindow = window
            }
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
