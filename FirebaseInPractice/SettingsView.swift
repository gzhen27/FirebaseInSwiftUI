//
//  SettingsView.swift
//  FirebaseInPractice
//
//  Created by G Zhen on 12/19/24.
//

import SwiftUI

@MainActor
@Observable
final class SettingsViewModel {
    var errorMessage: String?
    
    func signOut() throws {
        try AuthManager.shared.signOut()
    }
}

struct SettingsView: View {
    @State var viewModel = SettingsViewModel()
    @Binding var showSignInView: Bool
    
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.headline)
                }
                Button {
                    Task {
                        do {
                            try viewModel.signOut()
                            showSignInView = true
                        } catch {
                            viewModel.errorMessage = error.localizedDescription
                        }
                    }
                } label: {
                    Text("Log out")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                        .background(.black)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding(.top)
                }
            }
        }
        .padding()
        .navigationTitle("Settings")
    }
}

#Preview {
    NavigationStack {
        SettingsView(showSignInView: .constant(false))
    }
}
