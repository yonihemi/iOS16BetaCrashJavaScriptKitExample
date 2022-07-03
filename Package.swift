// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "iOS16Crash",
    products: [
        .executable(
            name: "iOS16Crash", targets: ["iOS16Crash"]
        ),
    ],
    dependencies: [
    	.package(name: "JavaScriptKit", url: "https://github.com/swiftwasm/JavaScriptKit.git", .branch("main")),
    	.package(name: "WebAPIKit", url: "https://github.com/swiftwasm/WebAPIKit.git", .branch("main"))
    ],
    
    targets: [
        .target(
            name: "iOS16Crash",
            dependencies: [
                "JavaScriptKit",
                .product(name: "JavaScriptEventLoop", package: "JavaScriptKit"),
                "WebAPIKit",
                //.product(name: "WebAPIKit", package: "WebAPIKit"))
            ]
        )
    ]
)
