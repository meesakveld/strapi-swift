//
//  PostData.swift
//  StrapiSwift
//
//  Created by Mees Akveld on 17/02/2025.
//

import Foundation

func postData<T: Decodable, U: Encodable>(to url: URL, body: U, as type: T.Type) async throws -> T {
    print("url: \(url)")
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    print("request: \(request)")

    // Voeg de token toe als authenticatie nodig is
    if let token = Strapi.getToken() {
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    }
    print("request: \(request)")

    // Encodeer de body als JSON
    request.httpBody = try JSONEncoder().encode(body)

    let (data, response) = try await URLSession.shared.data(for: request)
    print("data: \(data)")
    print("response: \(response)")

    // Controleer of de server een geldige HTTP 2xx-status heeft gegeven
    guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
        throw URLError(.badServerResponse)
    }

    // 🔹 Tijdelijke debug-functie om ruwe JSON te printen
    func debugRawJSON(_ data: Data) {
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            print("🔍 Ruwe JSON Response:", json)
        } catch {
            print("❌ Fout bij parsen van JSON:", error)
        }
    }

    // Debug de ruwe JSON
    debugRawJSON(data)

    // Decodeer de JSON naar het verwachte type
    return try JSONDecoder().decode(T.self, from: data)
}
