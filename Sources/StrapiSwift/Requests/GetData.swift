//
//  GetData.swift
//  StrapiSwift
//
//  Created by Mees Akveld on 16/02/2025.
//

import Foundation

func getData<T: Decodable>(from url: URL, as type: T.Type) async throws -> T {
    let (data, response) = try await URLSession.shared.data(from: url)
    
    // Controleer of de server een geldige HTTP 200-status heeft gegeven
    guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
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
