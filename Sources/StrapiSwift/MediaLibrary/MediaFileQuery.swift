//
//  MediaFileQuery.swift
//  StrapiSwift
//
//  Created by Mees Akveld on 06/03/2025.
//

import Foundation

@MainActor
public struct MediaFileQuery {
    private let id: Int
    private let baseURLProvider: () throws -> String
    
    init(id: Int, baseURLProvider: @escaping () throws -> String) {
        self.id = id
        self.baseURLProvider = baseURLProvider
    }
    
    /// Haalt een specifiek mediabestand op aan de hand van een ID
    public func getFile<T: Decodable>(as type: T.Type) async throws -> T {
        let baseURL = try baseURLProvider()
        let url = URL(string: "\(baseURL)/api/upload/files/\(id)")!
        
        return try await makeRequest(to: url, as: T.self)
    }
    
    /// Verwijdert een mediabestand op basis van een ID
    @discardableResult
    public func delete<T: Decodable>(as type: T.Type) async throws -> T {
        let baseURL = try baseURLProvider()
        let url = URL(string: "\(baseURL)/api/upload/files/\(id)")!
        
        return try await makeRequest(to: url, requestType: .DELETE,as: T.self)
    }
    
}
