// swift-tools-version: 6.1

import PackageDescription

// MARK: - Dependencies

let dependencies: [Package.Dependency] = [
  .package(url: "https://github.com/realm/realm-swift.git", exact: "20.0.1"),
  .package(url: "https://github.com/Alamofire/Alamofire.git", exact: "5.10.1"),
]

// MARK: - Targets

let targetInterfaces: Target = .target(
  name: "IPTVInterfaces",
  dependencies: [
    .product(name: "RealmSwift", package: "realm-swift"),
    .product(name: "Alamofire", package: "Alamofire"),
    "IPTVModels",
  ],
  path: "./Protocols",
)

let targetModels: Target = .target(
  name: "IPTVModels",
  dependencies: [
    .product(name: "RealmSwift", package: "realm-swift"),
  ],
  path: "./Models",
)

let targetComponents: Target = .target(
  name: "IPTVComponents",
  dependencies: [
    .product(name: "RealmSwift", package: "realm-swift"),
    .product(name: "Alamofire", package: "Alamofire"),
    "IPTVInterfaces",
    "IPTVModels",
  ],
  path: "./Library"
)

var targets: [Target] = [
  targetInterfaces,
  targetModels,
  targetComponents,
]

// MARK: - Package

let package = Package(
  name: "IPTVLibrary",
  defaultLocalization: "en",
  platforms: [
    .iOS(.v18),
    .tvOS(.v18),
  ],
  products: [
    .library(
      name: "IPTVComponents",
      targets: ["IPTVComponents"]
    ),
    .library(
      name: "IPTVModels",
      targets: ["IPTVModels"]
    ),
    .library(
      name: "IPTVInterfaces",
      targets: ["IPTVInterfaces"]
    ),
  ],
  dependencies: dependencies,
  targets: targets
)
