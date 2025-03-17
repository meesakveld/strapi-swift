//
//  File.swift
//  StrapiSwift
//
//  Created by Mees Akveld on 17/02/2025.
//

import Foundation

@MainActor
public struct LocalAuth {
    private let baseURLProvider: () throws -> String
    
    init(baseURLProvider: @escaping () throws -> String) {
        self.baseURLProvider = baseURLProvider
    }
    
    public struct AuthResponse<T: Decodable & Sendable>: Decodable, Sendable {
        public let jwt: String
        public let user: T
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
    
    @discardableResult
    public func login<T: Decodable>(identifier: String, password: String, as type: T.Type) async throws -> AuthResponse<T> {
        let baseURL = try baseURLProvider()
        let url = URL(string: baseURL + "/api/auth/local")!
        
        let userLogin = UserLogin(identifier: identifier, password: password)
        
        let response: AuthResponse<T> = try await makeRequest(to: url, requestType: .POST, body: userLogin, as: AuthResponse<T>.self)
        return response
    }
    
    @discardableResult
    public func register<T: Decodable>(username: String, email: String, password: String, as type: T.Type) async throws -> AuthResponse<T> {
        let baseURL = try baseURLProvider()
        let url = URL(string: baseURL + "/api/auth/local/register")!
        
        let userRegister = UserRegister(username: username, email: email, password: password)
        
        let response: AuthResponse<T> = try await makeRequest(to: url, requestType: .POST, body: userRegister, as: AuthResponse<T>.self)
        return response
    }
    
    @discardableResult
    public func changePassword<T: Decodable>(currentPassword: String, newPassword: String, as type: T.Type) async throws -> AuthResponse<T> {
        let baseURL = try baseURLProvider()
        let url = URL(string: baseURL + "/api/auth/change-password")!

        let passwordChange = PasswordChange(currentPassword: currentPassword, password: newPassword, passwordConfirmation: newPassword)
        
        let response: AuthResponse<T> = try await makeRequest(to: url, requestType: .POST, body: passwordChange, as: AuthResponse<T>.self)
        return response
    }
    
    @discardableResult
    public func updateProfile<T: Decodable>(_ data: StrapiRequestBody, userId: Int, as type: T.Type) async throws -> T {
        let baseURL = try baseURLProvider()
        let url = URL(string: baseURL + "/api/users/\(userId)")!
        return try await makeRequest(to: url, requestType: .PUT, body: data.data, as: T.self)
    }
    
    public func me<T: Decodable>(as type: T.Type) async throws -> T {
        let baseURL = try baseURLProvider()
        let url = URL(string: baseURL + "/api/users/me?populate=*")!
        return try await makeRequest(to: url, requestType: .GET, as: T.self)
    }
    
    public func me<T: Decodable>(extendUrl: String, requestType: HTTPMethod, data: StrapiRequestBody? = nil, as type: T.Type) async throws {
        let baseURL = try baseURLProvider()
        let url = baseURL + "/api/users/me" + extendUrl
        try await makeRequest(to: URL(string: url)!, requestType: requestType, body: data, as: T.self)
    }
}
