import ArgumentParser
import Hummingbird
import Foundation

@main
struct Server: ParsableCommand {
  @Option(name: .shortAndLong)
  var hostname: String = "127.0.0.1"

  @Option(name: .shortAndLong)
  var port: Int = 8080

  func run() throws {
    guard let location = HBEnvironment.shared.get("REDIRECT_LOCATION") else {
      fatalError("Specify the address to redirect to in the environment var `REDIRECT_LOCATION`")
    }
    let app = HBApplication(
      configuration: .init(
        address: .hostname(self.hostname, port: self.port),
        serverName: "Hummingbird"
      )
    )
    try app.configure(with: location)
    try app.start()
    app.wait()
  }
}

extension String {
  var droppingTrailingSlash: String {
    guard self.hasSuffix("/") else {
      return self
    }

    return String(self.dropLast())
  }
}

extension HBApplication {

  public func configure(with location: String) throws {
    let location = location.droppingTrailingSlash

    router.get("/healthy") { _ in
      "Healthy. Redirecting to: \(location)"
    }

    router.get("/*") { req -> HBResponse in
      HBResponse(
        status: .movedPermanently,
        headers: ["Location": location + req.uri.path]
      )
    }
    router.get("/") { _ in
      HBResponse(
        status: .movedPermanently,
        headers: ["Location": location]
      )
    }
  }
}
