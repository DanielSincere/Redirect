import Server
import Hummingbird
import HummingbirdXCT
import XCTest

final class ServerTests: XCTestCase {
  func testRedirect() throws {
    let app = HBApplication(testing: .live)
    try app.setupRedirects(to: "https://example.org")

    try app.XCTStart()
    defer { app.XCTStop() }

    try app.XCTExecute(uri: "/", method: .GET) { response in
      XCTAssertEqual(response.status, .movedPermanently)
      XCTAssertEqual(response.headers.first(name: "location"), "https://example.org")
      XCTAssertNil(response.body)
    }

    try app.XCTExecute(uri: "/example", method: .GET) { response in
      XCTAssertEqual(response.status, .movedPermanently)
      XCTAssertEqual(response.headers.first(name: "location"), "https://example.org")
      XCTAssertNil(response.body)
    }
  }
}
