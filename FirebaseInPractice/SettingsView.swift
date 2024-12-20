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
    var successMessage: String?
    
    func signOut() throws {
        try AuthManager.shared.signOut()
    }
    
    func resetPassword() async throws {
        let user = try? AuthManager.shared.getUser()
        
        guard let email = user?.email else {
            throw URLError(.fileDoesNotExist)
        }
        
        try await AuthManager.shared.resetPassword(email: email)
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
                if let successMessage = viewModel.successMessage {
                    Text(successMessage)
                        .foregroundColor(.green)
                        .font(.headline)
                }
                Button {
                    Task {
                        do {
                            try viewModel.signOut()
                            showSignInView = true
                        } catch {
                            viewModel.successMessage = nil
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
                
                Button {
                    Task {
                        do {
                            try await viewModel.resetPassword()
                            viewModel.errorMessage = nil
                            viewModel.successMessage = "Password reset email sent."
                        } catch {
                            viewModel.successMessage = nil
                            viewModel.errorMessage = error.localizedDescription
                        }
                    }
                } label: {
                    Text("Reset Password")
                        .underline(true, pattern: .solid, color: .black)
                        .foregroundStyle(.black)
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
