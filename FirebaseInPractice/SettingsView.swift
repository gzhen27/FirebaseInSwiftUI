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
    
    func updateEmail() async throws {
        let randomEmail = "\(UUID().uuidString)@example.com"
        try await AuthManager.shared.updateEmail(to: randomEmail)
    }
    
    func updatePassword() async throws {
        let password = "password"
        try await AuthManager.shared.updatePassword(to: password)
    }
}

struct SettingsView: View {
    @State var viewModel = SettingsViewModel()
    @Binding var showSignInView: Bool
    
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                
                messageSection
                
                signOutButton
                
                HStack {
                    updateEmailButton
                    updatePasswordButton
                }
                .frame(maxWidth: .infinity)
                
                resetPasswordButton
            }
        }
        .padding()
        .navigationTitle("Settings")
        .ignoresSafeArea(edges: .bottom)
    }
    
    private var messageSection: some View {
        Group {
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
            }
            if let successMessage = viewModel.successMessage {
                Text(successMessage)
                    .foregroundColor(.green)
            }
        }
        .font(.headline)
    }
    
    private var updateEmailButton: some View {
        Button {
            Task {
                do {
                    try await viewModel.updateEmail()
                    viewModel.errorMessage = nil
                    viewModel.successMessage = "Email updated."
                } catch {
                    viewModel.successMessage = nil
                    viewModel.errorMessage = error.localizedDescription
                }
            }
        } label: {
            Text("Update Email")
                .underline(true, pattern: .solid, color: .black)
                .foregroundStyle(.black)
        }
    }
    
    private var updatePasswordButton: some View {
        Button {
            Task {
                do {
                    try await viewModel.updatePassword()
                    viewModel.errorMessage = nil
                    viewModel.successMessage = "Password updated."
                } catch {
                    viewModel.successMessage = nil
                    viewModel.errorMessage = error.localizedDescription
                }
            }
        } label: {
            Text("Update Password")
                .underline(true, pattern: .solid, color: .black)
                .foregroundStyle(.black)
        }
    }
    
    private var resetPasswordButton: some View {
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
    
    private var signOutButton: some View {
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
            RoundedRectangle(cornerRadius: 6)
                .frame(height: 50)
                .foregroundStyle(.black)
                .overlay {
                    Text("Log out")
                        .foregroundColor(.white)
                        .font(.headline)
                }
        }
    }
}

#Preview {
    NavigationStack {
        SettingsView(showSignInView: .constant(false))
    }
}
