//
//  CollectionQueryTests.swift
//  StrapiSwift
//
//  Created by Mees Akveld on 22/03/2025.
//

import XCTest
@testable import StrapiSwift

@MainActor
final class CollectionQueryTests: XCTestCase {
    
    // Test: Filter methoden
    func testFilterMethod() {
        let query = CollectionQuery(collection: "posts", baseURLProvider: { return "https://api.example.com" })
        
        let filteredQuery = query.filter("title", operator: .contains, value: "swift")
        
        let expectedFilters: [String: Any] = [
            "title": ["$contains": "swift"]
        ]
        
        // Use a custom comparison function to compare filters
        XCTAssertTrue(areFiltersEqual(filteredQuery.filters, expectedFilters), "The filter should be applied correctly.")
    }
    
    // Test: Sort methoden
    func testSortMethod() {
        let query = CollectionQuery(collection: "posts", baseURLProvider: { return "https://api.example.com" })
        
        let sortedQuery = query.sort(by: "createdAt", order: .descending)
        
        let expectedSort: [[String: String]] = [
            ["createdAt": "desc"]
        ]
        
        XCTAssertEqual(sortedQuery.sort, expectedSort, "The sort should be applied correctly.")
    }
    
    // Test: Pagination methoden
    func testPaginationMethod() {
        let query = CollectionQuery(collection: "posts", baseURLProvider: { return "https://api.example.com" })
        
        let paginatedQuery = query.paginate(page: 1, pageSize: 10)
        
        let expectedPagination: [String: Int] = [
            "page": 1,
            "pageSize": 10
        ]
        
        XCTAssertEqual(paginatedQuery.pagination, expectedPagination, "The pagination should be applied correctly.")
    }
    
    // Test: Locale en status methoden
    func testLocaleAndStatusMethod() {
        let query = CollectionQuery(collection: "posts", baseURLProvider: { return "https://api.example.com" })
        
        let localizedQuery = query.locale("en").status("published")
        
        XCTAssertEqual(localizedQuery.locale, "en", "The locale should be set correctly.")
        XCTAssertEqual(localizedQuery.status, "published", "The status should be set correctly.")
    }
    
}

// Custom function to compare filters
func areFiltersEqual(_ filters1: [String: Any], _ filters2: [String: Any]) -> Bool {
    // If the dictionaries have different counts, they're not equal
    guard filters1.count == filters2.count else { return false }

    // Compare each key-value pair in the dictionaries
    for (key, value1) in filters1 {
        if let value2 = filters2[key] {
            // Check if both values are of the same type (e.g., Dictionary)
            if let dict1 = value1 as? [String: String], let dict2 = value2 as? [String: String] {
                // Compare dictionaries if both values are of the same type
                if dict1 != dict2 {
                    return false
                }
            } else {
                // If they are not of the same type or cannot be cast to comparable types, return false
                return false
            }
        } else {
            return false
        }
    }
    return true
}
