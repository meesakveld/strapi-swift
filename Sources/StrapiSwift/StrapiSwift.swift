// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import SwiftUI

@MainActor
public final class Strapi {
    private static var baseURL: String?
    private static var token: String?

    private init() {}

    /// Configureer de baseURL voor Strapi
    public static func configure(baseURL: String, token: String? = nil) {
        self.baseURL = baseURL
        self.token = token
    }

    /// Haal de baseURL op (geeft een fout als deze niet is ingesteld)
    private static func getBaseURL() throws -> String {
        guard let url = self.baseURL else {
            fatalError("Strapi is not configured. Call Strapi.configure(baseURL:) first.")
        }
        guard url != "" else {
            fatalError("Strapi baseURL is empty. Call Strapi.configure(baseURL:) first.")
        }
        return url
    }
    
    static func getToken() -> String? {
        guard let token = self.token else {
            print("Strapi is not configured with token. Call Strapi.configure(baseURL: , token:) to configure in case you need a token.")
            return nil
        }
        return token
    }

    /// Geeft een ContentManager instance terug
    public static var contentManager: ContentManager {
        return ContentManager(baseURLProvider: { try self.getBaseURL() })
    }
    
    /// Geef een Authentication instance terug
    public static var authentication: Authentication {
        return Authentication(baseURLProvider: { try self.getBaseURL() })
    }
}
