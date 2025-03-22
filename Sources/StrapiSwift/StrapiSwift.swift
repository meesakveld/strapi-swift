// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import SwiftUI

@MainActor
public final class Strapi {
    private static var baseURL: String?
    private static var token: String?
    private static var onceToken: String?
    
    private init() {}
    
    /// Configureer de baseURL voor Strapi
    public static func configure(baseURL: String, token: String? = nil) {
        self.baseURL = baseURL
        self.token = token
    }
    
    public static func useTokenOnce(token: String) {
        onceToken = token
    }
    
    static func resetOnceToken() {
        onceToken = nil
    }

    internal static func getBaseURL() throws -> String {
        guard let url = self.baseURL else {
            throw NSError(domain: "StrapiError", code: 2, userInfo: [NSLocalizedDescriptionKey: "Strapi baseURL is empty. Call Strapi.configure(baseURL:) first."])
        }
        guard url != "" else {
            throw NSError(domain: "StrapiError", code: 2, userInfo: [NSLocalizedDescriptionKey: "Strapi baseURL is empty. Call Strapi.configure(baseURL:) first."])
        }
        return url
    }
    
    static func getToken() -> (token: String?, useTokenOnce: Bool) {
        if let onceToken = self.onceToken {
            return (token: onceToken, useTokenOnce: true)
        } else if let token = self.token {
            return (token: token, useTokenOnce: false)
        } else {
            print("Strapi is not configured with token. Call Strapi.configure(baseURL:, token:) to configure in case you need a token.")
            return (token: nil, useTokenOnce: false)
        }
    }

    /// Geeft een ContentManager instance terug
    public static var contentManager: ContentManager {
        return ContentManager(baseURLProvider: { try self.getBaseURL() })
    }
    
    /// Geef een Authentication instance terug
    public static var authentication: Authentication {
        return Authentication(baseURLProvider: { try self.getBaseURL() })
    }
    
    /// Geef een MediaLibrary instance terug
    public static var mediaLibrary: MediaLibrary {
        return MediaLibrary(baseURLProvider: { try self.getBaseURL() })
    }
}
