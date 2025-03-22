//
//  SortOperatorTests.swift
//  StrapiSwiftTests
//
//  Created by Mees Akveld on 25/02/2025.
//

import XCTest
@testable import StrapiSwift

final class SortOperatorTests: XCTestCase {
    
    // MARK: - Test Raw Values
    func testSortOperatorRawValues() {
        XCTAssertEqual(SortOperator.ascending.rawValue, "asc", "The raw value for `.ascending` should be `asc`.")
        XCTAssertEqual(SortOperator.descending.rawValue, "desc", "The raw value for `.descending` should be `desc`.")
    }
    
    // MARK: - Test Full Name
    func testGetFullName() {
        XCTAssertEqual(SortOperator.ascending.getFullName(), "Ascending", "The full name for `.ascending` should be `Ascending`.")
        XCTAssertEqual(SortOperator.descending.getFullName(), "Descending", "The full name for `.descending` should be `Descending`.")
    }
    
    // MARK: - Test SF Symbols
    func testGetSFSymbol() {
        XCTAssertEqual(SortOperator.ascending.getSFSymbol(), "chevron.up", "The SF Symbol for `.ascending` should be `chevron.up`.")
        XCTAssertEqual(SortOperator.descending.getSFSymbol(), "chevron.down", "The SF Symbol for `.descending` should be `chevron.down`.")
    }
    
    // MARK: - Test Toggle Functionality
    func testToggle() {
        var sortOrder: SortOperator = .ascending
        sortOrder.toggle()
        XCTAssertEqual(sortOrder, .descending, "Toggling from `.ascending` should switch to `.descending`.")
        
        sortOrder.toggle()
        XCTAssertEqual(sortOrder, .ascending, "Toggling from `.descending` should switch back to `.ascending`.")
    }
}
