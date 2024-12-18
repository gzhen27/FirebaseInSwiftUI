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
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        Analytics.setAnalyticsCollectionEnabled(true)
        return true
    }
}
