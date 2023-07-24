import Server
import Hummingbird
import HummingbirdXCT
import XCTest

final class ServerTests: XCTestCase {
  func testRedirect() throws {
    let app = HBApplication(testing: .live)
    try app.configure(with: "https://example.org")

    try app.XCTStart()
    defer { app.XCTStop() }

    try app.XCTExecute(uri: "/", method: .GET) { response in
      XCTAssertEqual(response.status, .movedPermanently)
      XCTAssertEqual(response.headers.first(name: "location"), "https://example.org")
      XCTAssertNil(response.body)
    }

    try app.XCTExecute(uri: "/example", method: .GET) { response in
      XCTAssertEqual(response.status, .movedPermanently)
      XCTAssertEqual(response.headers.first(name: "location"), "https://example.org/example")
      XCTAssertNil(response.body)
    }

    try app.XCTExecute(uri: "/example/path", method: .GET) { response in
      XCTAssertEqual(response.status, .movedPermanently)
      XCTAssertEqual(response.headers.first(name: "location"), "https://example.org/example/path")
      XCTAssertNil(response.body)
    }

    try app.XCTExecute(uri: "/healthy123", method: .GET) { response in
      XCTAssertEqual(response.status, .movedPermanently)
      XCTAssertEqual(response.headers.first(name: "location"), "https://example.org/healthy123")
      XCTAssertNil(response.body)
    }

    try app.XCTExecute(uri: "/healthy", method: .GET) { response in
      XCTAssertEqual(response.status, .ok)
      XCTAssertEqual(response.headers.first(name: "location"), nil)
      XCTAssertEqual(response.body.map { String(buffer: $0) }, "Healthy. Redirecting to: https://example.org")
    }
  }

  func testRedirectWithTrailingSlash() throws {
    let app = HBApplication(testing: .live)
    try app.configure(with: "https://example.org/")

    try app.XCTStart()
    defer { app.XCTStop() }

    try app.XCTExecute(uri: "/", method: .GET) { response in
      XCTAssertEqual(response.status, .movedPermanently)
      XCTAssertEqual(response.headers.first(name: "location"), "https://example.org")
      XCTAssertNil(response.body)
    }

    try app.XCTExecute(uri: "/example", method: .GET) { response in
      XCTAssertEqual(response.status, .movedPermanently)
      XCTAssertEqual(response.headers.first(name: "location"), "https://example.org/example")
      XCTAssertNil(response.body)
    }

    try app.XCTExecute(uri: "/example/path", method: .GET) { response in
      XCTAssertEqual(response.status, .movedPermanently)
      XCTAssertEqual(response.headers.first(name: "location"), "https://example.org/example/path")
      XCTAssertNil(response.body)
    }

    try app.XCTExecute(uri: "/healthy123", method: .GET) { response in
      XCTAssertEqual(response.status, .movedPermanently)
      XCTAssertEqual(response.headers.first(name: "location"), "https://example.org/healthy123")
      XCTAssertNil(response.body)
    }

    try app.XCTExecute(uri: "/healthy", method: .GET) { response in
      XCTAssertEqual(response.status, .ok)
      XCTAssertEqual(response.headers.first(name: "location"), nil)
      XCTAssertEqual(response.body.map { String(buffer: $0) }, "Healthy. Redirecting to: https://example.org")
    }
  }
}
