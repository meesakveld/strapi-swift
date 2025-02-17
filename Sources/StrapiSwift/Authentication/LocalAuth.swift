//
//  File.swift
//  StrapiSwift
//
//  Created by Mees Akveld on 17/02/2025.
//

import Foundation

public struct LocalAuth {
    private let baseURLProvider: () throws -> String
    
    init(baseURLProvider: @escaping () throws -> String) {
        self.baseURLProvider = baseURLProvider
    }
    
    public struct AuthResponse<T: Decodable>: Decodable {
        let jwt: String
        let user: T
    }
    
    struct UserLogin: Encodable {
        let identifier: String
        let password: String
    }
    
    struct UserRegister: Encodable {
        let username: String
        let email: String
        let password: String
    }
    
    struct PasswordChange: Encodable {
        let currentPassword: String
        let password: String
        let passwordConfirmation: String
    }
    
    public func login<T: Decodable>(identifier: String, password: String, as type: T.Type) async throws -> AuthResponse<T> {
        let baseURL = try baseURLProvider()
        let url = URL(string: baseURL + "/api/auth/local")!
        
        let userLogin = UserLogin(identifier: identifier, password: password)
        
        let response: AuthResponse<T> = try await postData(to: url, body: userLogin, as: AuthResponse<T>.self)
        return response
    }
    
    public func register<T: Decodable>(username: String, email: String, password: String, as type: T.Type) async throws -> AuthResponse<T> {
        let baseURL = try baseURLProvider()
        let url = URL(string: baseURL + "/api/auth/local/register")!
        
        let userRegister = UserRegister(username: username, email: email, password: password)
        
        let response: AuthResponse<T> = try await postData(to: url, body: userRegister, as: AuthResponse<T>.self)
        return response
    }
    
    @discardableResult
    public func changePassword<T: Decodable>(currentPassword: String, newPassword: String, as type: T.Type) async throws -> AuthResponse<T> {
        let baseURL = try baseURLProvider()
        let url = URL(string: baseURL + "/api/auth/change-password")!

        let passwordChange = PasswordChange(currentPassword: currentPassword, password: newPassword, passwordConfirmation: newPassword)
        
        let response: AuthResponse<T> = try await postData(to: url, body: passwordChange, as: AuthResponse<T>.self)
        return response
    }
    
}
