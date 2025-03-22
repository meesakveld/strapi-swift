//
//  File.swift
//  StrapiSwift
//
//  Created by Mees Akveld on 22/03/2025.
//

import XCTest
@testable import StrapiSwift

final class FilterOperatorTests: XCTestCase {
    
    func testFilterOperatorRawValues() {
        XCTAssertEqual(FilterOperator.equal.rawValue, "$eq", "The raw value for `.equal` should be `$eq`.")
        XCTAssertEqual(FilterOperator.equalInsensitive.rawValue, "$eqi", "The raw value for `.equalInsensitive` should be `$eqi`.")
        XCTAssertEqual(FilterOperator.notEqual.rawValue, "$ne", "The raw value for `.notEqual` should be `$ne`.")
        XCTAssertEqual(FilterOperator.notEqualInsensitive.rawValue, "$nei", "The raw value for `.notEqualInsensitive` should be `$nei`.")
        XCTAssertEqual(FilterOperator.lessThan.rawValue, "$lt", "The raw value for `.lessThan` should be `$lt`.")
        XCTAssertEqual(FilterOperator.lessThanOrEqual.rawValue, "$lte", "The raw value for `.lessThanOrEqual` should be `$lte`.")
        XCTAssertEqual(FilterOperator.greaterThan.rawValue, "$gt", "The raw value for `.greaterThan` should be `$gt`.")
        XCTAssertEqual(FilterOperator.greaterThanOrEqual.rawValue, "$gte", "The raw value for `.greaterThanOrEqual` should be `$gte`.")
        XCTAssertEqual(FilterOperator.includedIn.rawValue, "$in", "The raw value for `.includedIn` should be `$in`.")
        XCTAssertEqual(FilterOperator.notIncludedIn.rawValue, "$notIn", "The raw value for `.notIncludedIn` should be `$notIn`.")
        XCTAssertEqual(FilterOperator.contains.rawValue, "$contains", "The raw value for `.contains` should be `$contains`.")
        XCTAssertEqual(FilterOperator.notContains.rawValue, "$notContains", "The raw value for `.notContains` should be `$notContains`.")
        XCTAssertEqual(FilterOperator.containsInsensitive.rawValue, "$containsi", "The raw value for `.containsInsensitive` should be `$containsi`.")
        XCTAssertEqual(FilterOperator.notContainsInsensitive.rawValue, "$notContainsi", "The raw value for `.notContainsInsensitive` should be `$notContainsi`.")
        XCTAssertEqual(FilterOperator.isNull.rawValue, "$null", "The raw value for `.isNull` should be `$null`.")
        XCTAssertEqual(FilterOperator.isNotNull.rawValue, "$notNull", "The raw value for `.isNotNull` should be `$notNull`.")
        XCTAssertEqual(FilterOperator.isBetween.rawValue, "$between", "The raw value for `.isBetween` should be `$between`.")
        XCTAssertEqual(FilterOperator.startsWith.rawValue, "$startsWith", "The raw value for `.startsWith` should be `$startsWith`.")
        XCTAssertEqual(FilterOperator.startsWithInsensitive.rawValue, "$startsWithi", "The raw value for `.startsWithInsensitive` should be `$startsWithi`.")
        XCTAssertEqual(FilterOperator.endsWith.rawValue, "$endsWith", "The raw value for `.endsWith` should be `$endsWith`.")
        XCTAssertEqual(FilterOperator.endsWithInsensitive.rawValue, "$endsWithi", "The raw value for `.endsWithInsensitive` should be `$endsWithi`.")
    }
    
    func testAllFilterOperatorsAreCovered() {
        // Ensure that all enum cases are tested (a safeguard for future expansions)
        let allCases: [FilterOperator] = [
            .equal, .equalInsensitive, .notEqual, .notEqualInsensitive, .lessThan, .lessThanOrEqual,
            .greaterThan, .greaterThanOrEqual, .includedIn, .notIncludedIn, .contains, .notContains,
            .containsInsensitive, .notContainsInsensitive, .isNull, .isNotNull, .isBetween,
            .startsWith, .startsWithInsensitive, .endsWith, .endsWithInsensitive
        ]
        
        XCTAssertEqual(FilterOperator.allCases.count, allCases.count, "The number of cases in the enum should match the expected list.")
    }
}
