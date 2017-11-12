// swift-tools-version:4.0.0

import PackageDescription

let package = Package(
  name: "S3",
  products: [
    .library(name: "S3", targets: ["S3"]),
  ],
  dependencies: [
    .package(url: "https://github.com/vapor/vapor.git", .upToNextMajor(from: "2.3.0")),
    .package(url: "https://github.com/JustinM1/S3SignerAWS.git", .upToNextMajor(from: "3.0.2"))
  ],
  targets: [
    .target(
      name: "S3",
      dependencies: ["Vapor", "S3SignerAWS"]
     )
  ]
)