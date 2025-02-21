//
//  StrapiSwiftError.swift
//  StrapiSwift
//
//  Created by Mees Akveld on 21/02/2025.
//

import Foundation

public enum StrapiSwiftError: Error {
    case badResponse(statusCode: Int, message: String?)
    case decodingError(Error)
    case unknownError(Error)

    var localizedDescription: String {
        switch self {
        case .badResponse(let statusCode, let message):
            return "Server responded with status code \(statusCode). \(message ?? "No additional details.")"
        case .decodingError(let error):
            return "Error decoding data: \(error.localizedDescription)"
        case .unknownError(let error):
            return "Unknown error occurred: \(error.localizedDescription)"
        }
    }
}
