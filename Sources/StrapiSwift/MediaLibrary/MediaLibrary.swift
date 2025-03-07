//
//  MediaLibrary.swift
//  StrapiSwift
//
//  Created by Mees Akveld on 06/03/2025.
//

import Foundation

@MainActor
public struct MediaLibrary {
    private let baseURLProvider: () throws -> String

    public init(baseURLProvider: @escaping () throws -> String) {
        self.baseURLProvider = baseURLProvider
    }

    public var files: MediaFilesQuery {
        return MediaFilesQuery(baseURLProvider: self.baseURLProvider)
    }
    
}
