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
  name: "EventView",
  platforms: [.iOS(.v14)],
  products: [
    .library(
      name: "EventView",
      targets: ["EventView"]),
  ],
  dependencies: [
    .package(path: "\(Path.Container.domain)/AddaMeModels"),
    .package(path: "\(Path.Container.core)/AsyncImageLoder"),
    .package(path: "\(Path.Container.core)/AttachmentClient"),
    .package(path: "\(Path.Container.core)/FuncNetworking"),
    .package(path: "\(Path.Container.core)/InfoPlist"),
    .package(path: "\(Path.Container.core)/KeychainService"),
    .package(path: "\(Path.Container.core)/FoundationExtension"),
    .package(path: "\(Path.Container.core)/SwiftUIExtension"),
    .package(path: "\(Path.Container.services)/LocationClient"),
    .package(path: "\(Path.Container.services)/PathMonitorClient"),
    .package(path: "\(Path.Container.services)/UserClient"),
    .package(path: "\(Path.Container.services)/WebsocketClient"),
    .package(path: "\(Path.Container.services)/ConversationClient"),
    .package(path: "\(Path.Container.services)/ChatClient"),
    .package(path: "\(Path.Container.services)/EventClient"),
    .package(path: "\(Path.Container.views)/ChatView")
  ],
  targets: [
    .target(
      name: "EventView",
      dependencies: ["AddaMeModels", "AsyncImageLoder", "AttachmentClient", "ConversationClient", "ChatClient", "EventClient", "FuncNetworking", "InfoPlist", "KeychainService", "LocationClient", "FoundationExtension", "SwiftUIExtension", "PathMonitorClient", "UserClient", "WebsocketClient", "ChatView"]),
    .testTarget(
      name: "EventViewTests",
      dependencies: ["EventView"]),
  ]
)
