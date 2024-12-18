//
//  FirebaseInPracticeApp.swift
//  FirebaseInPractice
//
//  Created by G Zhen on 12/18/24.
//

import SwiftUI
import Firebase

@main
struct FirebaseInPracticeApp: App {
    
    init() {
        FirebaseApp.configure()
        Analytics.setAnalyticsCollectionEnabled(true)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
