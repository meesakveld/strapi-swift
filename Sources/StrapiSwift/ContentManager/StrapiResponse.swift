//
//  StrapiResponse.swift
//  StrapiSwift
//
//  Created by Mees Akveld on 13/02/2025.
//

import Foundation

@MainActor
public struct StrapiResponse<T: Decodable & Sendable>: Decodable & Sendable {
    let data: T
    let meta: Meta?
}

public struct Meta: Decodable & Sendable {
    let pagination: Pagination?
}

public struct Pagination: Decodable & Sendable {
    let page: Int
    let pageSize: Int
    let pageCount: Int
    let total: Int
}
