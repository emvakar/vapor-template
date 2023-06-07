// swift-tools-version:5.8
import PackageDescription

let package = Package(
    name: "Template",
    platforms: [
       .macOS(.v12)
    ],
    dependencies: [
        // 💧 A server-side Swift web framework.
        .package(url: "https://github.com/vapor/vapor.git", from: "4.77.0"),
        .package(url: "https://github.com/vapor/fluent.git", from: "4.8.0"),
        .package(url: "https://github.com/vapor/fluent-postgres-driver.git", from: "2.7.2"),
        .package(url: "https://github.com/vapor/leaf.git", from: "4.2.4"),
        .package(url: "https://github.com/vapor/jwt.git", from: "4.0.0"),
        .package(url: "https://github.com/MihaelIsaev/FCM.git", from: "2.0.0"),
        .package(url: "https://github.com/MihaelIsaev/VaporCron.git", from: "2.0.0"),
        .package(url: "https://github.com/emvakar/FJWTMiddleware.git", from: "1.0.0"),
        .package(url: "https://github.com/emvakar/uniqueid", from: "1.0.5"),
        .package(url: "https://github.com/nerzh/telegram-vapor-bot", from: "1.6.3"),
    ],
    targets: [
        .executableTarget(
            name: "App",
            dependencies: [
                .product(name: "Leaf", package: "leaf"),
                .product(name: "Vapor", package: "vapor"),
                .product(name: "Fluent", package: "fluent"),
                .product(name: "FluentPostgresDriver", package: "fluent-postgres-driver"),
                .product(name: "JWT", package: "jwt"),
                .product(name: "FCM", package: "FCM"),
                .product(name: "VaporCron", package: "VaporCron"),
                .product(name: "FJWTMiddleware", package: "FJWTMiddleware"),
                .product(name: "UniqueID", package: "uniqueid"),
                .product(name: "telegram-vapor-bot", package: "telegram-vapor-bot"),
            ],
            swiftSettings: [
                // Enable better optimizations when building in Release configuration. Despite the use of
                // the `.unsafeFlags` construct required by SwiftPM, this flag is recommended for Release
                // builds. See <https://www.swift.org/server/guides/building.html#building-for-production> for details.
                .unsafeFlags(["-cross-module-optimization"], .when(configuration: .release))
            ]
        ),
        .testTarget(name: "AppTests", dependencies: [
            .target(name: "App"),
            .product(name: "XCTVapor", package: "vapor"),
        ])
    ]
)
