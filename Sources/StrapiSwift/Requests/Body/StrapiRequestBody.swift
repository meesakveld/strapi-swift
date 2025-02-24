//
//  StrapiRequestBody.swift
//  StrapiSwift
//
//  Created by Mees Akveld on 22/02/2025.
//

import Foundation

/// A struct used to represent the body of a request to Strapi API.
///
/// This struct conforms to `Encodable` to ensure it can be serialized into JSON when making requests to Strapi.
/// The body is expected to have a `data` field which holds a dictionary of key-value pairs.
/// The values in the dictionary are encoded as `AnyCodable`, which allows for flexibility in handling different types of data.
///
/// This struct is typically used in `POST` and `PUT` requests to create or update resources in Strapi.
///
/// Example usage:
/// ```swift
/// let data: StrapiRequestBody = StrapiRequestBody([
///     "firstname": .string("Mees"),
///     "age": .int(22),
/// ])
/// ```
/// In a `POST` request, this would create a new resource in Strapi.
/// In a `PUT` request, this would update an existing resource in Strapi.
///
/// - Parameter data: A dictionary where the keys are strings and the values are `AnyCodable` types.
///
public struct StrapiRequestBody: Encodable {
    public let data: [String: AnyCodable]

    public init(_ data: [String: AnyCodable]) {
        self.data = data
    }
}
