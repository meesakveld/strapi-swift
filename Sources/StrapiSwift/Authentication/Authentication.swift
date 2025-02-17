//
//  Authentication.swift
//  StrapiSwift
//
//  Created by Mees Akveld on 17/02/2025.
//

import Foundation

public struct Authentication {
    private let baseURLProvider: () throws -> String

    public init(baseURLProvider: @escaping () throws -> String) {
        self.baseURLProvider = baseURLProvider
    }

    public var local: LocalAuth {
        return LocalAuth(baseURLProvider: self.baseURLProvider)
    }
}
