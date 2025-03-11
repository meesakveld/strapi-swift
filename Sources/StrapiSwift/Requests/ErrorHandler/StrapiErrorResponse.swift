//
//  File.swift
//  StrapiSwift
//
//  Created by Mees Akveld on 21/02/2025.
//

import Foundation

struct StrapiErrorResponse: Decodable {
    let data: String?
    let error: StrapiErrorDetails
}

struct StrapiErrorDetails: Decodable {
    let status: Int
    let name: String
    let message: String
    let details: StrapiErrorDetailsArray
}

struct StrapiErrorDetailsArray: Decodable {
    let errors: [StrapiErrorDetailsArraySlices]
}

struct StrapiErrorDetailsArraySlices: Decodable {
    let path: [String]
    let message: String
    let name: String
    let value: String
}
