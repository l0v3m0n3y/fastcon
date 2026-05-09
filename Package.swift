// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "fastcon",
    platforms: [
        .macOS(.v12), .iOS(.v15)
    ],
    products: [
        .library(name: "fastcon", targets: ["fastcon"]),
    ],
    targets: [
        .target(
            name: "fastcon",
            path: "src"
        ),
    ]
)
