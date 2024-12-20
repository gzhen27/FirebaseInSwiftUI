//
//  SignInEmailView.swift
//  FirebaseInPractice
//
//  Created by G Zhen on 12/19/24.
//

import SwiftUI

@Observable
@MainActor
final class SignInEmailViewModel {
    var email = ""
    var password = ""
    var errorMessage: String?
    
    func signUp() async throws {
        clearMessage()
        
        guard !email.isEmpty || !password.isEmpty else {
            errorMessage = "The email or password is missing"
            return
        }
        
        print("Signing up user...")
        try await AuthManager.shared.createUser(email: email, password: password)
    }
    
    func signIn() async throws {
        clearMessage()
        
        guard !email.isEmpty || !password.isEmpty else {
            errorMessage = "The email or password is missing"
            return
        }
        
        print("Signing in user...")
        try await AuthManager.shared.signIn(email: email, password: password)
    }
    
    private func clearMessage() {
        errorMessage = nil
    }
}

struct SignInEmailView: View {
    @State private var viewModel: SignInEmailViewModel = .init()
    @Binding var showSignInView: Bool
    
    var body: some View {
        VStack(spacing: 12) {
            Group {
                TextField("Email...", text: $viewModel.email)
                SecureField("Password...", text: $viewModel.password)
            }
            .padding()
            .background(.gray.opacity(0.2))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            
            
            Button {
                Task {
                    do {
                        try await viewModel.signUp()
                        showSignInView = false
                        return
                    } catch {
                        viewModel.errorMessage = error.localizedDescription
                    }
                    
                    do {
                        try await viewModel.signIn()
                        showSignInView = false
                        return
                    } catch {
                        viewModel.errorMessage = error.localizedDescription
                    }
                }
            } label: {
                Text("Sign In")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(.black)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(.top)
            }
            
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.callout)
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle("Sign In with Email")
    }
}

#Preview {
    NavigationStack {
        SignInEmailView(showSignInView: .constant(false))
    }
}
