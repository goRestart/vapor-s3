import XCTest
@testable import S3

class S3Tests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertEqual(S3().text, "Hello, World!")
    }


    static var allTests = [
        ("testExample", testExample),
    ]
}
