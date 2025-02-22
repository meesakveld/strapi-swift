//
//  DocumentQuery.swift
//  StrapiSwift
//
//  Created by Mees Akveld on 13/02/2025.
//

import Foundation

@MainActor
public struct DocumentQuery {
    private let collection: String
    private let documentId: String
    private let baseURLProvider: () throws -> String
    private var populate: [String: PopulateQuery] = [:]

    init(collection: String, documentId: String, baseURLProvider: @escaping () throws -> String) {
        self.collection = collection
        self.documentId = documentId
        self.baseURLProvider = baseURLProvider
    }

    /// Voeg een `populate`-optie toe, maar alleen ná `withDocumentId`
    public func populate(_ field: String, _ configure: ((inout PopulateQuery) -> Void)? = nil) -> DocumentQuery {
        var query = self
        if let configure = configure {
            var subquery = PopulateQuery()
            configure(&subquery)
            query.populate[field] = subquery
        } else {
            query.populate[field] = PopulateQuery()
        }
        return query
    }

    /// Bouw de API URL met populate-opties
    private func buildURL() throws -> URL {
        let baseURL = try baseURLProvider()
        let urlString = "\(baseURL)/api/\(collection)/\(documentId)"
        
        var queryItems: [URLQueryItem] = []

        // Populate toevoegen
        print("populate: \(populate)")
        for (field, subquery) in populate {
            let subqueryDict = subquery.toDictionary()
            queryItems.append(contentsOf: buildPopulateQuery(field: field, dict: subqueryDict))
        }

        var components = URLComponents(string: urlString)
        components?.queryItems = queryItems.isEmpty ? nil : queryItems

        guard let url = components?.url else {
            throw URLError(.badURL)
        }
        return url
    }

    /// Helper om de populate-query op te bouwen
    private func buildPopulateQuery(field: String, dict: [String: Any]) -> [URLQueryItem] {
        var items: [URLQueryItem] = []

        if dict.isEmpty {
            items.append(URLQueryItem(name: "populate[\(field)]", value: "true"))
            return items
        }

        for (key, value) in dict {
            let baseKey = "populate[\(field)][\(key)]"
            
            if let arrayValues = value as? [String], !arrayValues.isEmpty {
                for (index, val) in arrayValues.enumerated() {
                    items.append(URLQueryItem(name: "\(baseKey)[\(index)]", value: val))
                }
            } else if let dictValues = value as? [String: Any], !dictValues.isEmpty {
                items.append(contentsOf: buildPopulateQuery(field: "\(field)][\(key)", dict: dictValues))
            } else if let stringValue = value as? String {
                items.append(URLQueryItem(name: baseKey, value: stringValue))
            }
        }

        return items
    }
    
    //MARK: - GET DOCUMENT
    public func getDocument<T: Decodable & Sendable>(as type: T.Type) async throws -> StrapiResponse<T> {
        let url = try buildURL()
        return try await makeRequest(to: url, as: StrapiResponse<T>.self)
    }
    
    //MARK: - PostData
    public func putData<T: Encodable & Sendable>(_ data: StrapiRequestBody, as type: T.Type) async throws -> StrapiResponse<T> {
        let url = try buildURL()
        return try await makeRequest(to: url, requestType: .PUT, body: data, as: StrapiResponse<T>.self)
    }
}
