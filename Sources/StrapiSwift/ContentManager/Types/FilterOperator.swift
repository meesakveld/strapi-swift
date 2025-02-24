//
//  FilterOperator.swift
//  StrapiSwift
//
//  Created by Mees Akveld on 24/02/2025.
//

import Foundation

public enum FilterOperator: String {
    case equal = "$eq"
    case equalInsensitive = "$eqi"
    case notEqual = "$ne"
    case notEqualInsensitive = "$nei"
    case lessThan = "$lt"
    case lessThanOrEqual = "$lte"
    case greaterThan = "$gt"
    case greaterThanOrEqual = "$gte"
    case includedIn = "$in"
    case notIncludedIn = "$notIn"
    case contains = "$contains"
    case notContains = "$notContains"
    case containsInsensitive = "$containsi"
    case notContainsInsensitive = "$notContainsi"
    case isNull = "$null"
    case isNotNull = "$notNull"
    case isBetween = "$between"
    case startsWith = "$startsWith"
    case startsWithInsensitive = "$startsWithi"
    case endsWith = "$endsWith"
    case endsWithInsensitive = "$endsWithi"
    case or = "$or"
    case and = "$and"
    case not = "$not"
}
