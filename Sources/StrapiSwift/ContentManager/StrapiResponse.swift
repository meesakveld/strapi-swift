//
//  File.swift
//  StrapiSwift
//
//  Created by Mees Akveld on 13/02/2025.
//

import Foundation

/// 🎯 Wrapper voor Strapi API response (indien nodig)
struct StrapiResponse<T: Decodable>: Decodable {
    let data: T
}
