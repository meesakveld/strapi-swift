import Testing
@testable import StrapiSwift

@Test func testPrinter() async throws {
    let output = printer("Hello, Swift!")
    #expect(output == "Hello, Swift!")
}
