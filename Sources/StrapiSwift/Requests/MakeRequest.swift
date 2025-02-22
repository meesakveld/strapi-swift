//
//  MakeRequest.swift
//  StrapiSwift
//
//  Created by Mees Akveld on 22/02/2025.
//

import Foundation

enum HTTPMethod: String {
    case GET, POST, PUT
}

struct EmptyBody: Encodable {}

@MainActor
func makeRequest<T: Decodable & Sendable, U: Encodable>(
    to url: URL,
    requestType: HTTPMethod = .GET,
    body: U? = EmptyBody(),
    as type: T.Type
) async throws -> T {
    print("url: \(url)")
    var request = URLRequest(url: url)
    request.httpMethod = requestType.rawValue
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    // Voeg de token toe als authenticatie nodig is
    if let token = Strapi.getToken() {
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    }

    // Encodeer de body alleen als deze aanwezig is en niet voor GET
    if let body = body, requestType != .GET {
        request.httpBody = try JSONEncoder().encode(body)
    }
    
    let (data, response) = try await URLSession.shared.data(for: request)

    // Debug output
    print("data: \(data)")
    if let stringResponse = String(data: data, encoding: .utf8) {
        print("Response body: \(stringResponse)")
    }
    print("response: \(response)")

    // Controleer of de server een geldige HTTP 200-status heeft gegeven
    guard let httpResponse = response as? HTTPURLResponse else {
        throw StrapiSwiftError.unknownError(URLError(.badServerResponse))
    }

    if httpResponse.statusCode != 200 {
        let errorMessage = extractStrapiErrorMessage(from: data)
        throw StrapiSwiftError.badResponse(statusCode: httpResponse.statusCode, message: errorMessage)
    }

    // Debug ruwe JSON
    func debugRawJSON(_ data: Data) {
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            print("🔍 Ruwe JSON Response:", json)
        } catch {
            print("❌ Fout bij parsen van JSON:", error)
        }
    }
    debugRawJSON(data)

    return try JSONDecoder().decode(T.self, from: data)
}
