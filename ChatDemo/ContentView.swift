//
//  ContentView.swift
//  ChatDemo
//
//  Created by ISHOWSPEED on 2024/07/07.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            MainMessagesView()
                .tabItem {
                    Image(systemName: "message")
                    Text("Messages")
                }
            
            SettingsView()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

