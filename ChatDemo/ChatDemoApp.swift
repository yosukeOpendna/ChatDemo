//
//  ChatDemoApp.swift
//  ChatDemo
//
//  Created by ISHOWSPEED on 2024/06/01.
//

import SwiftUI
import Firebase
import FirebaseStorage
@main
struct ChatDemoApp: App {
    init() {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            MainMessagesView()
        }
    }
}
