//
//  StrapiResponse.swift
//  StrapiSwift
//
//  Created by Mees Akveld on 13/02/2025.
//

import Foundation

@MainActor
public struct StrapiResponse<T: Decodable & Sendable>: Decodable & Sendable {
    public let data: T
    public let meta: Meta?
}

public struct Meta: Decodable & Sendable {
    public let pagination: Pagination?
}

public struct Pagination: Decodable & Sendable {
    public let page: Int?
    public let pageSize: Int?
    public let pageCount: Int?
    public let limit: Int?
    public let start: Int?
    public let total: Int?
}
