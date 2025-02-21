//
//  ExtractErrorMessage.swift
//  StrapiSwift
//
//  Created by Mees Akveld on 21/02/2025.
//

import Foundation

func extractStrapiErrorMessage(from data: Data) -> String? {
    do {
        let errorResponse = try JSONDecoder().decode(StrapiErrorResponse.self, from: data)
        return errorResponse.error.message
    } catch {
        print("❌ Fout bij het decoderen van de foutmelding:", error)
        return nil
    }
}
