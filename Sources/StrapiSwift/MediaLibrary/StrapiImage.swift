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
    public func getSmallestFormat() -> String? {
        if let thumbnailUrl = formats?.thumbnail?.url {
            return thumbnailUrl
        } else if let smallUrl = formats?.small?.url {
            return smallUrl
        } else if let mediumUrl = formats?.medium?.url {
            return mediumUrl
        } else if let largeUrl = formats?.large?.url {
            return largeUrl
        } else {
            return url
        }
    }
}
