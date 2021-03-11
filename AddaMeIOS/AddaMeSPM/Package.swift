// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

enum Path {
  static let modules = "../Modules"
  enum Container {
    static let core = "\(Path.modules)/Core"
    static let domain = "\(Path.modules)/Domain"
    static let services = "\(Path.modules)/Services"
    static let views = "\(Path.modules)/Views"
  }
}

let package = Package(
  name: "AddaMeSPM",
  platforms: [.iOS(.v14)],
  products: [
    .library(
      name: "AddaMeSPM",
      targets: ["AddaMeSPM"]),
  ],
  dependencies: [
    .package(path: "\(Path.Container.core)/AsyncImageLoder"),
    .package(path: "\(Path.Container.core)/FoundationExtension"),
    .package(path: "\(Path.Container.core)/FuncNetworking"),
    .package(path: "\(Path.Container.core)/InfoPlist"),
    .package(path: "\(Path.Container.core)/KeychainService"),
    .package(path: "\(Path.Container.core)/SwiftUIExtension"),
    .package(path: "\(Path.Container.domain)/AddaMeModels"),
    .package(path: "\(Path.Container.services)/AttachmentClient"),
    .package(path: "\(Path.Container.services)/AuthClient"),
    .package(path: "\(Path.Container.services)/ChatClient"),
    .package(path: "\(Path.Container.services)/ConversationClient"),
    .package(path: "\(Path.Container.services)/EventClient"),
    .package(path: "\(Path.Container.services)/LocationClient"),
    .package(path: "\(Path.Container.services)/PathMonitorClient"),
    .package(path: "\(Path.Container.services)/UserClient"),
    .package(path: "\(Path.Container.services)/WebsocketClient"),
    .package(path: "\(Path.Container.views)/EventView"),
    .package(path: "\(Path.Container.views)/UserView")
  ],
  targets: [
    .target(
      name: "AddaMeSPM",
      dependencies: [
        "AsyncImageLoder", "FoundationExtension", "FuncNetworking", "InfoPlist",
        "KeychainService", "SwiftUIExtension", "AddaMeModels", "AttachmentClient",
        "AuthClient", "ChatClient", "ConversationClient", "EventClient", "LocationClient",
        "PathMonitorClient", "UserClient", "WebsocketClient", "EventView", "UserView",
        .product(name: "AttachmentClientLive", package: "AttachmentClient"),
        .product(name: "AuthClientLive", package: "AuthClient"),
        .product(name: "ChatClientLive", package: "ChatClient"),
        .product(name: "ConversationClientLive", package: "ConversationClient"),
        .product(name: "EventClientLive", package: "EventClient"),
        .product(name: "LocationClientLive", package: "LocationClient"),
        .product(name: "PathMonitorClientLive", package: "PathMonitorClient"),
        .product(name: "UserClientLive", package: "UserClient"),
        .product(name: "WebsocketClientLive", package: "WebsocketClient")
      ]),
    .testTarget(
      name: "AddaMeSPMTests",
      dependencies: ["AddaMeSPM"]),
  ]
)
