import XCTest
@testable import StrapiSwift

@MainActor
final class StrapiSwiftTests: XCTestCase {
    
    override func setUp() async throws {
        // Reset configuration and tokens before each test
        Strapi.configure(baseURL: "")
        Strapi.resetOnceToken()
    }
    
    // MARK: - Test baseURL configuration
    /// Tests that Strapi correctly configures and retrieves the baseURL.
    func testConfigureBaseURL() async throws {
        let testBaseURL = "https://test-strapi.com"
        Strapi.configure(baseURL: testBaseURL)
        
        let baseURL = try Strapi.getBaseURL()
        XCTAssertEqual(baseURL, testBaseURL, "The baseURL should match the configured value.")
    }
    
    // MARK: - Test token configuration
    /// Tests that Strapi correctly configures and retrieves a token.
    func testConfigureToken() async throws {
        let testToken = "12345-test-token"
        Strapi.configure(baseURL: "https://test-strapi.com", token: testToken)
        
        let tokenResult = Strapi.getToken()
        XCTAssertEqual(tokenResult.token, testToken, "The retrieved token should match the configured token.")
        XCTAssertFalse(tokenResult.useTokenOnce, "The token should not be marked as a one-time-use token.")
    }
    
    // MARK: - Test usage of one-time (once) token
    /// Tests that a one-time-use token is correctly set and retrieved.
    func testUseOnceToken() async throws {
        let onceToken = "once-token-12345"
        Strapi.useTokenOnce(token: onceToken)
        
        let tokenResult = Strapi.getToken()
        XCTAssertEqual(tokenResult.token, onceToken, "The retrieved token should match the one-time-use token.")
        XCTAssertTrue(tokenResult.useTokenOnce, "The token should be marked as a one-time-use token.")
    }
    
    // MARK: - Test reset of one-time token
    /// Tests that the one-time-use token is properly reset.
    func testResetOnceToken() async throws {
        Strapi.useTokenOnce(token: "temporary-token")
        Strapi.resetOnceToken()  // Reset one-time token
        
        let tokenResult = Strapi.getToken()
        XCTAssertNil(tokenResult.token, "The one-time token should be reset to nil.")
        XCTAssertFalse(tokenResult.useTokenOnce, "After resetting, there should be no active one-time token.")
    }
    
    // MARK: - Test empty baseURL configuration
    /// Tests that configuring an empty baseURL causes a fatal error.
    func testEmptyBaseURL() {
        Strapi.configure(baseURL: "")
        XCTAssertThrowsError(try Strapi.getBaseURL()) { error in
            XCTAssertEqual(error.localizedDescription, "Strapi baseURL is empty. Call Strapi.configure(baseURL:) first.",
                           "The error message should indicate that the baseURL is empty.")
        }
    }
    
    // MARK: - Test access to subsystem objects
    /// Tests that `contentManager`, `authentication`, and `mediaLibrary` return valid instances.
    func testAccessors() async throws {
        Strapi.configure(baseURL: "https://test-strapi.com")
        
        let contentManager = Strapi.contentManager
        let authentication = Strapi.authentication
        let mediaLibrary = Strapi.mediaLibrary
        
        XCTAssertNotNil(contentManager, "ContentManager should be properly returned.")
        XCTAssertNotNil(authentication, "Authentication should be properly returned.")
        XCTAssertNotNil(mediaLibrary, "MediaLibrary should be properly returned.")
    }
}
