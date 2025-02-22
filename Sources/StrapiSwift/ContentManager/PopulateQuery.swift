//
//  PopulateQuery.swift
//  StrapiSwift
//
//  Created by Mees Akveld on 16/02/2025.
//

import Foundation

@MainActor
public struct PopulateQuery {
    private var subPopulates: [String: PopulateQuery] = [:]

    /// Voeg een sub-populate toe
    public mutating func populate(_ field: String, _ configure: ((inout PopulateQuery) -> Void)? = nil) {
        var subquery = PopulateQuery()
        configure?(&subquery)
        subPopulates[field] = subquery
    }

    /// Converteer de subquery naar een dictionary-formaat voor URL-building
    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [:]

        if !subPopulates.isEmpty {
            var subDict: [String: Any] = [:]
            for (key, value) in subPopulates {
                let subPopulateDict = value.toDictionary()
                subDict[key] = subPopulateDict.isEmpty ? "true" : subPopulateDict
            }
            dict["populate"] = subDict
        }

        return dict
    }
}
