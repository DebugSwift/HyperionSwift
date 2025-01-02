//
//  ContentView.swift
//  Example
//
//  Created by Matheus Gois on 01/01/25.
//

import SwiftUI
import HyperionSwift

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
            
            Text("Click to Open")
                .font(.largeTitle)
                .onTapGesture {
                    HyperionSwift.shared.present()
                }
            
        }
        .padding()
        .onAppear {
            HyperionSwift.shared.setup()
        }
    }
}


#Preview {
    ContentView()
}
