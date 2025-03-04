//
//  File.swift
//  StrapiSwift
//
//  Created by Mees Akveld on 04/03/2025.
//

import Foundation

public struct FilterGroup {
    public enum LogicOperator: String {
        case and = "$and"
        case or = "$or"
    }
    
    var type: LogicOperator
    var filters: [[String: Any]] = []
    
    public mutating func filter(_ field: String, operator: FilterOperator, value: Any) {
        filters.append([field: [`operator`.rawValue: value]])
    }
    
    func toDictionary() -> [String: Any] {
        return [type.rawValue: filters]
    }
}
