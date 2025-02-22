//
//  CollectionQuery.swift
//  StrapiSwift
//
//  Created by Mees Akveld on 13/02/2025.
//

import Foundation

@MainActor
public struct CollectionQuery {
    private let collection: String
    private let baseURLProvider: () throws -> String
    
    private var filters: [String: Any] = [:]
    private var populate: [String: PopulateQuery] = [:]
    private var fields: [String] = []
    private var sort: [String] = []
    private var pagination: [String: Int] = [:]
    private var locale: String?
    private var status: String?
    
    init(collection: String, baseURLProvider: @escaping () throws -> String) {
        self.collection = collection
        self.baseURLProvider = baseURLProvider
    }

    /// Voeg een filter toe
    public func filter(_ field: String, isEqualTo value: Any) -> CollectionQuery {
        var query = self
        query.filters[field] = ["$eq": value]
        return query
    }

    /// Sorteer de resultaten
    public func sort(by field: String, order: String = "asc") -> CollectionQuery {
        var query = self
        query.sort.append("\(field):\(order)")
        return query
    }

    /// Definieer welke velden moeten worden opgehaald
    public func withFields(_ fields: [String]) -> CollectionQuery {
        var query = self
        query.fields = fields
        return query
    }

    /// 🚀 Voeg een `populate` optie toe met een closure voor verdere configuratie
    public func populate(_ field: String, _ configure: ((inout PopulateQuery) -> Void)? = nil) -> CollectionQuery {
        var query = self
        if let configure = configure {
            var subquery = PopulateQuery()
            configure(&subquery)
            query.populate[field] = subquery
        } else {
            query.populate[field] = PopulateQuery() // Populate zonder configuratie
        }
        return query
    }
    
    /// Pagination with page and pageSize
    public func paginate(page: Int, pageSize: Int) -> CollectionQuery {
        var query = self
        query.pagination = ["page": page, "pageSize": pageSize]
        return query
    }
    
    /// Pagination with start (default = 0) and limit
    public func paginate(start: Int = 0, limit: Int) -> CollectionQuery {
        var query = self
        query.pagination = ["start": start, "limit": limit]
        return query
    }

    /// Stel de locale in
    public func locale(_ locale: String) -> CollectionQuery {
        var query = self
        query.locale = locale
        return query
    }

    /// Stel de status in
    public func status(_ status: String) -> CollectionQuery {
        var query = self
        query.status = status
        return query
    }
    
    public func withDocumentId(_ documentId: String) -> DocumentQuery {
        return DocumentQuery(collection: self.collection, documentId: documentId, baseURLProvider: self.baseURLProvider)
    }
    
    //MARK: - BUILD URL
    private func buildURL() throws -> URL {
        let baseURL = try baseURLProvider()
        let urlString = "\(baseURL)/api/\(collection)"
        
        var queryItems: [URLQueryItem] = []

        // Filters
        for (field, condition) in filters {
            for (operatorKey, value) in condition as! [String: Any] {
                queryItems.append(URLQueryItem(name: "filters[\(field)][\(operatorKey)]", value: "\(value)"))
            }
        }

        // Populate
        for (field, subquery) in populate {
            let subqueryDict = subquery.toDictionary()
            queryItems.append(contentsOf: buildPopulateQuery(field: field, dict: subqueryDict))
        }

        // Sortering
        for (index, value) in sort.enumerated() {
            queryItems.append(URLQueryItem(name: "sort[\(index)]", value: value))
        }

        // Velden
        for (index, value) in fields.enumerated() {
            queryItems.append(URLQueryItem(name: "fields[\(index)]", value: value))
        }

        // Paginering
        for (key, value) in pagination {
            queryItems.append(URLQueryItem(name: "pagination[\(key)]", value: "\(value)"))
        }

        // Locale en status
        if let locale = locale {
            queryItems.append(URLQueryItem(name: "locale", value: locale))
        }
        if let status = status {
            queryItems.append(URLQueryItem(name: "status", value: status))
        }

        var components = URLComponents(string: urlString)
        components?.queryItems = queryItems

        guard let url = components?.url else {
            throw URLError(.badURL)
        }
        return url
    }

    /// Bouw query-items voor populates op basis van een geneste dictionary
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
    
    
    //MARK: - GET DOCUMENTS
    /// Fetch de documenten
    public func getDocuments<T: Decodable & Sendable>(as type: T.Type) async throws -> StrapiResponse<T> {
        let url = try buildURL()
        return try await makeRequest(to: url, as: StrapiResponse<T>.self)
    }
    
    
    //MARK: - PostData
    public func postData<T: Decodable & Sendable>(_ data: StrapiRequestBody, as type: T.Type) async throws -> StrapiResponse<T> {
        let url = try buildURL()
        return try await makeRequest(to: url, requestType: .POST, body: data, as: StrapiResponse<T>.self)
    }

}
