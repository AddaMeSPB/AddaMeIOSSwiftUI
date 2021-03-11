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
  name: "UserView",
  platforms: [.iOS(.v14)],
  products: [
    .library(
      name: "UserView",
      targets: ["UserView"]),
  ],
  dependencies: [
    .package(path: "\(Path.Container.domain)/AddaMeModels"),
    .package(path: "\(Path.Container.core)/AsyncImageLoder"),
    .package(path: "\(Path.Container.core)/FoundationExtension"),
    .package(path: "\(Path.Container.core)/FuncNetworking"),
    .package(path: "\(Path.Container.core)/InfoPlist"),
    .package(path: "\(Path.Container.core)/KeychainService"),
    .package(path: "\(Path.Container.core)/SwiftUIExtension"),
    .package(path: "\(Path.Container.services)/AuthClient"),
    .package(path: "\(Path.Container.services)/AttachmentClient"),
    .package(path: "\(Path.Container.services)/EventClient"),
    .package(path: "\(Path.Container.services)/UserClient"),
  ],
  targets: [
    .target(
      name: "UserView",
      dependencies: ["AuthClient", "AddaMeModels", "SwiftUIExtension", "FoundationExtension", "EventClient", "AttachmentClient", "AsyncImageLoder" ,"FuncNetworking", "KeychainService", "InfoPlist", "UserClient"]),
    .testTarget(
      name: "UserViewTests",
      dependencies: ["UserView"]),
  ]
)
