//
//  AuthenticationTests.swift
//  StrapiSwiftTests
//
//  Created by Mees Akveld on 17/02/2025.
//

import XCTest
@testable import StrapiSwift

@MainActor
final class AuthenticationTests: XCTestCase {
    
    // MARK: - Test Initialization with Valid baseURLProvider
    /// Tests that the `Authentication` instance is correctly initialized when a valid baseURL is provided.
    func testAuthenticationInitializationWithValidBaseURL() async throws {
        let testBaseURL = "https://valid-strapi.com"
        
        // Create Authentication instance using a valid baseURLProvider
        let auth = Authentication(baseURLProvider: { testBaseURL })
        
        // Assert that `auth.local` returns a `LocalAuth` instance
        let localAuth = auth.local
        XCTAssertNotNil(localAuth, "The local property should return a valid LocalAuth instance.")
    }
    
    // MARK: - Test Initialization with Throwing baseURLProvider
    /// Tests that the `Authentication` instance handles a throwing baseURLProvider correctly.
    func testAuthenticationInitializationWithThrowingBaseURLProvider() async throws {
        let auth = Authentication(baseURLProvider: { throw NSError(domain: "StrapiError", code: 1, userInfo: [NSLocalizedDescriptionKey: "BaseURL error"]) })
        
        // Assert that calling `auth.local` does not crash, but instead maintains stability.
        XCTAssertNoThrow(auth.local, "Accessing `auth.local` should not crash even if the baseURLProvider throws an error.")
    }
    
    // MARK: - Test `local` Access
    /// Tests that the `local` property returns a `LocalAuth` instance.
    func testLocalAccess() async throws {
        let testBaseURL = "https://test-strapi.com"
        let auth = Authentication(baseURLProvider: { testBaseURL })
        
        let localAuth = auth.local
        XCTAssertNotNil(localAuth, "The `local` property should return a valid `LocalAuth` instance.")
    }
    
    // MARK: - Test `baseURLProvider` Throws Error
    /// Tests that the `baseURLProvider` throwing an error results in appropriate error handling.
    func testBaseURLProviderThrowsError() async throws {
        let errorMessage = "Simulated baseURL error"
        
        // Create Authentication instance with a throwing baseURLProvider
        let auth = Authentication(baseURLProvider: { throw NSError(domain: "StrapiError", code: 1, userInfo: [NSLocalizedDescriptionKey: errorMessage]) })
        
        do {
            _ = try auth.baseURLProvider() // Attempt to access the baseURL, which should throw
            XCTFail("Accessing baseURLProvider should throw an error.")
        } catch {
            XCTAssertEqual(error.localizedDescription, errorMessage, "The thrown error message should match the expected error.")
        }
    }
}
