import ProjectDescription

let project = Project(
  name: "MergeableSystemLibraryRepro",
  targets: [
    .target(
      name: "ReproApp",
      destinations: .macOS,
      product: .app,
      bundleId: "dev.repro.mergeable-system-library",
      deploymentTargets: .macOS("14.0"),
      infoPlist: .default,
      sources: ["Sources/**"],
      dependencies: [
        .external(name: "GRDB"),
        .external(name: "GRDBSQLite"),
      ],
      settings: .settings(
        base: [
          "MERGED_BINARY_TYPE": "automatic",
        ]
      )
    ),
    .target(
      name: "ReproAppTests",
      destinations: .macOS,
      product: .unitTests,
      bundleId: "dev.repro.mergeable-system-library.tests",
      deploymentTargets: .macOS("14.0"),
      infoPlist: .default,
      sources: ["Tests/**"],
      dependencies: [
        .target(name: "ReproApp"),
        .external(name: "GRDBSQLite"),
      ]
    ),
  ]
)
