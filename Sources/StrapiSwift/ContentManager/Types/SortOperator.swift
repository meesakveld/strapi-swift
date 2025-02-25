//
//  SortOperator.swift
//  StrapiSwift
//
//  Created by Mees Akveld on 25/02/2025.
//

import Foundation

/// An enum that represents the sorting order for query parameters.
///
/// - `descending`: Sorts the results in descending order (`desc`).
/// - `ascending`: Sorts the results in ascending order (`asc`).
///
/// **Note:** In Strapi, `asc` is the default sorting order if no explicit sort is provided.
///
/// This enum also provides methods to retrieve the full name of the sorting order and the corresponding SF Symbol.
public enum SortOperator: String {
    case descending = "desc"
    case ascending = "asc"
    
    /// Returns the full name of the sorting order.
    ///
    /// - Returns: A `String` representing the full name of the sorting order.
    ///
    /// Example:
    /// ```swift
    /// let sortOrder = SortOperator.ascending
    /// print(sortOrder.getFullName()) // Output: "Ascending"
    /// ```
    public func getFullName() -> String {
        switch self {
        case .descending:
            return "Descending"
        case .ascending:
            return "Ascending"
        }
    }
    
    /// Returns the appropriate SF Symbol name for the sorting order.
    ///
    /// - Returns: A `String` representing the SF Symbol name for the sorting order.
    ///
    /// Example:
    /// ```swift
    /// let sortOrder = SortOperator.ascending
    /// print(sortOrder.getSFSymbol()) // Output: "chevron.up"
    /// ```
    public func getSFSymbol() -> String {
        switch self {
        case .descending:
            return "chevron.down"
        case .ascending:
            return "chevron.up"
        }
    }
    
    /// Toggles between ascending and descending sorting orders.
    ///
    /// - Modifies the current `SortOperator` instance to the opposite sorting order.
    /// - If the current order is `.ascending`, it will change to `.descending` and vice versa.
    ///
    /// Example:
    /// ```swift
    /// var sortOrder = SortOperator.ascending
    /// sortOrder.toggle() // Changes to .descending
    /// print(sortOrder.getFullName()) // Output: "Descending"
    /// ```
    public mutating func toggle() {
        switch self {
        case .descending:
            self = .ascending
        case .ascending:
            self = .descending
        }
    }
}
