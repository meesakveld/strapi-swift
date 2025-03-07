//
//  StrapiImage.swift
//  StrapiSwift
//
//  Created by Mees Akveld on 23/02/2025.
//

import Foundation

public struct StrapiImage: Identifiable, Codable {
    public var id: Int
    public var documentId: String
    public var name: String
    public var alternativeText: String?
    public var caption: String?
    public var width: Int?
    public var height: Int?
    public var url: String
    public var formats: ImageFormats?
    public var createdAt: String
    public var updatedAt: String
    public var publishedAt: String
    
    public struct ImageFormats: Codable {
        public var thumbnail: ImageFormat?
        public var small: ImageFormat?
        public var medium: ImageFormat?
        public var large: ImageFormat?
        
        public struct ImageFormat: Codable {
            public var url: String
        }
    }
    
    // MARK: - Utils
    public enum ImageSize {
        case thumbnail
        case small
        case medium
        case large
        case original
    }

    public func getURL(size: ImageSize) -> String {
        switch size {
        case .thumbnail:
            return formats?.thumbnail?.url
                ?? formats?.small?.url
                ?? formats?.medium?.url
                ?? formats?.large?.url
                ?? url
        case .small:
            return formats?.small?.url
                ?? formats?.medium?.url
                ?? formats?.large?.url
                ?? url
        case .medium:
            return formats?.medium?.url
                ?? formats?.large?.url
                ?? url
        case .large:
            return formats?.large?.url
                ?? url
        case .original:
            return url
        }
    }
}
