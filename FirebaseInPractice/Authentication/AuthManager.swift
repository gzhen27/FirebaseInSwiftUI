//
//  AuthManager.swift
//  FirebaseInPractice
//
//  Created by G Zhen on 12/19/24.
//

import Foundation
import FirebaseAuth

struct AuthDataResultModel {
    let uid: String?
    let email: String?
    let photoURL: String?
    
    init(user: User) {
        uid = user.uid
        email = user.email
        photoURL = user.photoURL?.absoluteString
    }
}

final class AuthManager {
    
    static let shared = AuthManager()
    private init() {}
    
    func getUser() throws -> AuthDataResultModel {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)
        }
        
        return AuthDataResultModel(user: user)
    }
    
    func createUser(email: String, password: String) async throws -> AuthDataResultModel {
        let authResult = try await Auth.auth().createUser(withEmail: email, password: password)
        return AuthDataResultModel(user: authResult.user)
    }
    
    func signOut() throws {
       try Auth.auth().signOut()
    }
    
}
