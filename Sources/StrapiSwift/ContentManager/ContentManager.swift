//
//  ContentManager.swift
//  StrapiSwift
//
//  Created by Mees Akveld on 13/02/2025.
//

import Foundation
import SwiftUI

public struct ContentManager {
    private let baseURLProvider: () throws -> String

    init(baseURLProvider: @escaping () throws -> String) {
        self.baseURLProvider = baseURLProvider
    }

    public func collection(_ name: String) -> CollectionQuery {
        return CollectionQuery(collection: name, baseURLProvider: baseURLProvider)
    }
}
