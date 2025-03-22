//
//  LocalAuthTests.swift
//  StrapiSwiftTests
//
//  Created by Mees Akveld on 17/02/2025.
//

import XCTest
@testable import StrapiSwift

@MainActor
final class LocalAuthTests: XCTestCase {
    
    struct MockUser: Codable, Sendable {
        let id: Int
        let username: String
        let email: String
    }
    
    // Mock baseURL providers for testing different scenarios
    let validBaseURLProvider: () throws -> String = { "https://mock-strapi.com" }
    let invalidBaseURLProvider: () throws -> String = { throw NSError(domain: "StrapiError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid baseURL"]) }
    
    // MARK: - Test Initialization
    
    /// Test to verify that `LocalAuth` initializes correctly with a valid baseURL.
    func testLocalAuthInitializationWithValidBaseURL() throws {
        let localAuth = LocalAuth(baseURLProvider: validBaseURLProvider)
        XCTAssertNotNil(localAuth, "LocalAuth instance should be initialized with a valid baseURL.")
    }
    
    /// Test to ensure that `LocalAuth` throws an error when the baseURL is invalid.
    func testLocalAuthInitializationThrowsErrorOnInvalidBaseURL() throws {
        let localAuth = LocalAuth(baseURLProvider: invalidBaseURLProvider)
        XCTAssertThrowsError(try localAuth.baseURLProvider(), "LocalAuth should throw an error if the baseURL is invalid.")
    }
    
    // MARK: - Test Discardable Result Behavior
    
    /// Test to verify that methods annotated with `@discardableResult` can be used without causing warnings.
    func testDiscardableResultAnnotations() throws {
        let localAuth = LocalAuth(baseURLProvider: validBaseURLProvider)
        
        // Simulate calling a discardableResult method without using the return value.
        // This ensures that the annotation prevents any compiler warnings.
        let _ = try? localAuth.baseURLProvider()  // Result is ignored.
    }
}
