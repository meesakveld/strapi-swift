import Foundation

// Functie voor het versturen van data naar de server met een POST-verzoek
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
    
    if let stringResponse = String(data: data, encoding: .utf8) {
        print("Response body: \(stringResponse)")
    }
    
    print("response: \(response)")

    // Controleer of de server een geldige HTTP 200-status heeft gegeven
    guard let httpResponse = response as? HTTPURLResponse else {
        throw StrapiSwiftError.unknownError(URLError(.badServerResponse))
    }
    
    if httpResponse.statusCode != 200 {
        // Probeer het foutbericht van de server te halen
        let errorMessage = extractStrapiErrorMessage(from: data)
        throw StrapiSwiftError.badResponse(statusCode: httpResponse.statusCode, message: errorMessage)
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
