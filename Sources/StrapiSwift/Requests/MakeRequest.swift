//
//  MakeRequest.swift
//  StrapiSwift
//
//  Created by Mees Akveld on 22/02/2025.
//

import Foundation

enum HTTPMethod: String {
    case GET, POST, PUT, DELETE
}

enum ContentType {
    case applicationJSON
    case multipartFormData(boundary: String)
    
    var rawValue: String {
        switch self {
        case .applicationJSON:
            return "application/json"
        case .multipartFormData(let boundary):
            return "multipart/form-data; boundary=\(boundary)"
        }
    }
}

struct EmptyBody: Encodable {}

enum RequestError: Error {
    case noDataAvailable
}

@MainActor
@discardableResult
func makeRequest<T: Decodable, U: Encodable>(
    to url: URL,
    requestType: HTTPMethod = .GET,
    contentType: ContentType = .applicationJSON,
    body: U? = EmptyBody(),
    as type: T.Type
) async throws -> T {
    print("url: \(url)")
    var request = URLRequest(url: url)
    request.httpMethod = requestType.rawValue
    request.setValue(contentType.rawValue, forHTTPHeaderField: "Content-Type")
    
    // Voeg de token toe als authenticatie nodig is
    let tokenObject = Strapi.getToken()
    if let token = tokenObject.token {
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        if tokenObject.useTokenOnce {
            Strapi.resetOnceToken()
        }
    }

    // Encodeer de body alleen als deze aanwezig is en niet voor GET
    if let body = body, requestType != .GET {
        if contentType.rawValue == "application/json" {
            request.httpBody = try JSONEncoder().encode(body)
        } else {
            request.httpBody = body as? Data
        }
    }
    
    let (data, response) = try await URLSession.shared.data(for: request)

    // Debug output
    print("data: \(data)")
    if let stringResponse = String(data: data, encoding: .utf8) {
        print("Response body: \(stringResponse)")
    }

    // Controleer of de server een geldige HTTP 200-status heeft gegeven
    guard let httpResponse = response as? HTTPURLResponse else {
        throw StrapiSwiftError.unknownError(URLError(.badServerResponse))
    }

    if httpResponse.statusCode != 200 && httpResponse.statusCode != 201 && httpResponse.statusCode != 204 {
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

    guard !data.isEmpty else {
        throw RequestError.noDataAvailable
    }
    
    return try JSONDecoder().decode(T.self, from: data)
}
