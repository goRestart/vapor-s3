// swift-tools-version:3.1

import PackageDescription

let package = Package(
    name: "S3",
    dependencies: [
    	.Package(url: "https://github.com/vapor/vapor.git", majorVersion: 2),
    	.Package(url: "https://github.com/vzsg/S3SignerAWS.git", majorVersion: 2)
    ]
)
