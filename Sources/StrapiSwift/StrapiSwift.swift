// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import SwiftUI

/// 🎯 Singleton actor voor thread-safe gebruik van Strapi
public final actor Strapi: @unchecked Sendable {
    private static var baseURL: String?

    private init() {}

    /// Configureer de baseURL voor Strapi
    public static func configure(baseURL: String) {
        self.baseURL = baseURL
    }

    /// Haal de baseURL op (geeft een fout als deze niet is ingesteld)
    private static func getBaseURL() throws -> String {
        guard let url = self.baseURL else {
            fatalError("Strapi is not configured. Call Strapi.configure(baseURL:) first.")
        }
        return url
    }

    /// Geeft een ContentManager instance terug
    public static var contentManager: ContentManager {
        return ContentManager(baseURLProvider: { try self.getBaseURL() })
    }
}
