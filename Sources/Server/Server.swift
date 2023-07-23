import ArgumentParser
import Hummingbird

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

extension HBApplication {
  public func configure(with location: String) throws {

    router.get("/healthy") { _ in
      "Healthy. Redirecting to: \(location)"
    }

    let redirectResponse = HBResponse(
      status: .movedPermanently,
      headers: ["Location": location]
    )

    router.get("/*") { _ in
      redirectResponse
    }
    router.get("/") { _ in
      redirectResponse
    }
  }
}
