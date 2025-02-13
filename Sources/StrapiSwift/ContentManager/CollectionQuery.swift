//
//  File.swift
//  StrapiSwift
//
//  Created by Mees Akveld on 13/02/2025.
//

import Foundation

/// 🎯 Object dat collectie-query's beheert (zonder document ID)
public struct CollectionQuery {
    private let collection: String
    private let baseURLProvider: () throws -> String
    private var filters: [String: String] = [:]
    private var sortField: String?
    private var descending: Bool = false

    init(collection: String, baseURLProvider: @escaping () throws -> String) {
        self.collection = collection
        self.baseURLProvider = baseURLProvider
    }

    /// Selecteer een specifiek document via ID en schakel over naar `DocumentQuery`
    public func withDocumentId(_ id: String) -> DocumentQuery {
        return DocumentQuery(collection: collection, documentId: id, baseURLProvider: baseURLProvider)
    }

    /// Voeg een filter toe aan de query
    public func `where`(_ field: String, isEqualTo value: String) -> CollectionQuery {
        var query = self
        query.filters[field] = value
        return query
    }

    /// Sorteer de resultaten
    public func order(by field: String, descending: Bool = false) -> CollectionQuery {
        var query = self
        query.sortField = field
        query.descending = descending
        return query
    }

    /// Fetch een lijst van documenten
    public func getDocuments() /* <T: Decodable>(as type: T.Type) */ async throws /* -> [T] */ {
        let url = try buildURL()
        print("GET DOCUMENTS", url)
//        return try await fetchData(url: url, as: type) as! [T]
    }

    /// 🔗 Bouw de API URL voor collecties
    private func buildURL() throws -> URL {
        let baseURL = try baseURLProvider()
        print("BASE URL: \(baseURL)")
        let urlString = "\(baseURL)/api/\(collection)"
        print("URL STRING: \(urlString)")

        var queryItems: [URLQueryItem] = filters.map { URLQueryItem(name: "filters[\($0.key)]", value: $0.value) }

        if let sortField = sortField {
            let order = descending ? "desc" : "asc"
            queryItems.append(URLQueryItem(name: "sort", value: "\(sortField):\(order)"))
        }

        var components = URLComponents(string: urlString)
        components?.queryItems = queryItems.isEmpty ? nil : queryItems

        guard let url = components?.url else {
            throw URLError(.badURL)
        }
        return url
    }

    /// 🛠 Algemene fetch-functie
    private func fetchData<T: Decodable>(url: URL, as type: T.Type) async throws -> T {
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        return try JSONDecoder().decode(StrapiResponse<T>.self, from: data).data
    }
}
