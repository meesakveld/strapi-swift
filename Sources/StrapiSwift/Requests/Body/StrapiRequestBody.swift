//
//  StrapiRequestBody.swift
//  StrapiSwift
//
//  Created by Mees Akveld on 22/02/2025.
//

import Foundation

public struct StrapiRequestBody: Encodable {
    public let data: [String: AnyCodable]

    public init(_ data: [String: AnyCodable]) {
        self.data = data
    }
}
