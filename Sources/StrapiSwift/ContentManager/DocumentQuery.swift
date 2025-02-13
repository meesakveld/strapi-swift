//
//  File.swift
//  StrapiSwift
//
//  Created by Mees Akveld on 13/02/2025.
//

import Foundation

/// 🎯 Object dat een specifieke document-query beheert (alleen mogelijk na `withId`)
public struct DocumentQuery {
    private let collection: String
    private let documentId: String
    private let baseURLProvider: () throws -> String

    init(collection: String, documentId: String, baseURLProvider: @escaping () throws -> String) {
        self.collection = collection
        self.documentId = documentId
        self.baseURLProvider = baseURLProvider
    }

    /// Fetch een specifiek document
    public func getDocument() /* <T: Decodable>(as type: T.Type) */ async throws /* -> T */ {
        let url = try buildURL()
        print(url)
//        return try await fetchData(url: url, as: type)
    }

    /// 🔗 Bouw de API URL voor een specifiek document
    private func buildURL() throws -> URL {
        let baseURL = try baseURLProvider()
        let urlString = "\(baseURL)/api/\(collection)/\(documentId)"

        guard let url = URL(string: urlString) else {
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
