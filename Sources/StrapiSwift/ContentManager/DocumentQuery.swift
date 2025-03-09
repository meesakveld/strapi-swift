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
    private var filters: [String: Any] = [:]
    private var filterGroups: [FilterGroup] = []
    private var populate: [String: PopulateQuery] = [:]

    init(collection: String, documentId: String, baseURLProvider: @escaping () throws -> String) {
        self.collection = collection
        self.documentId = documentId
        self.baseURLProvider = baseURLProvider
    }
    
    public func filter(_ field: String, operator: FilterOperator, value: Any) -> DocumentQuery {
        var query = self
        query.filters[field] = [`operator`.rawValue: value]
        return query
    }
    
    public func filterGroup(type: FilterGroup.LogicOperator, _ configure: (inout FilterGroup) -> Void) -> DocumentQuery {
        var query = self
        var group = FilterGroup(type: type)
        configure(&group)
        query.filterGroups.append(group)
        return query
    }

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

        // Filters
        for (field, condition) in filters {
            for (operatorKey, value) in condition as! [String: Any] {
                queryItems.append(URLQueryItem(name: "filters\(field)[\(operatorKey)]", value: "\(value)"))
            }
        }
        
        // Filtergroepen ($or, $and)
        for (_, group) in filterGroups.enumerated() {
            let groupDict = group.toDictionary()
            if let filtersArray = groupDict[group.type.rawValue] as? [[String: Any]] {
                for (filterIndex, filter) in filtersArray.enumerated() {
                    for (field, condition) in filter {
                        for (operatorKey, value) in condition as! [String: Any] {
                            let key = "filters[\(group.type.rawValue)][\(filterIndex)]\(field)[\(operatorKey)]"
                            queryItems.append(URLQueryItem(name: key, value: "\(value)"))
                        }
                    }
                }
            }
        }
        
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
    
    //MARK: - DELETE DOCUMENT
    public func delete() async throws {
        let url = try buildURL()
        do {
            try await makeRequest(to: url, requestType: .DELETE, as: Bool?.self)
        } catch _ as RequestError {
        } catch { throw error }
    }
}
