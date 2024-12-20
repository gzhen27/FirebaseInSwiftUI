//
//  RootView.swift
//  FirebaseInPractice
//
//  Created by G Zhen on 12/19/24.
//

import SwiftUI

struct RootView: View {
    @State private var showSignInView: Bool = false
    
    var body: some View {
        ZStack {
            NavigationStack {
                SettingsView(showSignInView: $showSignInView)
            }
        }
        .onAppear {
            let user = try? AuthManager.shared.getUser()
            showSignInView = user == nil
        }
        .fullScreenCover(isPresented: $showSignInView) {
            NavigationStack {
                SignInMethodsView(showSignInView: $showSignInView)
            }
        }
    }
}

#Preview {
    RootView()
}
