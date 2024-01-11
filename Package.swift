// swift-tools-version:5.7.0

import PackageDescription

let package = Package(
    name: "PaltaLibAnalytics",
    platforms: [.iOS(.v11)],
    products: [
        .library(
            name: "PaltaLibAnalytics",
            targets: [
                "PaltaLibAnalytics"
            ]
        )
    ],
    dependencies: [
        .package(
            url: "https://github.com/amplitude/Amplitude-iOS.git",
            from: "8.16.4"
        ),
        .package(
            url: "https://github.com/Palta-Data-Platform/paltalib-swift-core.git",
            from: "3.2.2"
        ),
        .package(
            url: "https://github.com/krzysztofzablocki/Difference.git",
            from: "1.0.2"
        )
    ],
    targets: [
        .target(
            name: "PaltaLibAnalytics",
            dependencies: [
                .product(name: "Amplitude", package: "Amplitude-iOS"),
                .product(name: "PaltaCore", package: "paltalib-swift-core")
            ],
            path: "Sources/Analytics"
        ),
        .testTarget(
            name: "AnalyticsTests",
            dependencies: [
                "PaltaLibAnalytics",
                .product(name: "Difference", package: "Difference")
            ]
        )
    ]
)
