// swift-tools-version: 6.0

import PackageDescription

#if TUIST
import ProjectDescription

let packageSettings = PackageSettings(
  productTypes: [
    "GRDB": .framework,
  ],
  baseSettings: .settings(
    configurations: [
      .debug(name: "Debug"),
      .release(name: "Release"),
    ]
  )
)
#endif

let package = Package(
  name: "ReproDependencies",
  platforms: [
    .macOS(.v14),
  ],
  dependencies: [
    .package(url: "https://github.com/groue/GRDB.swift", exact: "7.10.0"),
  ]
)
