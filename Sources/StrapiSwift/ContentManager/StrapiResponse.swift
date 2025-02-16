//
//  StrapiResponse.swift
//  StrapiSwift
//
//  Created by Mees Akveld on 13/02/2025.
//

import Foundation

/// 🎯 Wrapper voor Strapi API response (indien nodig)
public struct StrapiResponse<T: Decodable>: Decodable {
    let data: T
    let meta: Meta?
}

public struct Meta: Decodable {
    let pagination: Pagination?
}

public struct Pagination: Decodable {
    let page: Int
    let pageSize: Int
    let pageCount: Int
    let total: Int
}
