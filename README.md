# Tuist mergeable system-library code-signing repro

This minimal project demonstrates that Tuist materializes GRDB's SwiftPM
`GRDBSQLite` `systemLibrary` target as a macOS framework containing a real
top-level `Modules` directory. The generated framework fails strict code-sign
verification. This can also break Xcode's Debug re-export path when
`MERGED_BINARY_TYPE=automatic` if the invalid directory is retained in
`Contents/ReexportedBinaries`.

## Reproduce

```sh
./tuist_bin/tuist install
./tuist_bin/tuist generate --no-open

xcodebuild build \
  -workspace MergeableSystemLibraryRepro.xcworkspace \
  -scheme ReproApp \
  -configuration Debug \
  -destination 'platform=macOS,arch=arm64' \
  -derivedDataPath /tmp/tuist-mergeable-system-library-repro \
  CODE_SIGN_STYLE=Manual \
  CODE_SIGN_IDENTITY=- \
  DEVELOPMENT_TEAM=

codesign --verify --deep --strict --verbose=4 \
  /tmp/tuist-mergeable-system-library-repro/Build/Products/Debug/GRDBSQLite.framework
```

The final command consistently fails:

```text
unsealed contents present in the root directory of an embedded framework
```

The generated `GRDBSQLite` target contains a `Copy Module Map` script that
writes:

```text
GRDBSQLite.framework/Modules/module.modulemap
```

On macOS, the framework root must contain only `Versions` and symlinks.

In a larger workspace, Xcode's automatic mergeable-library Debug re-export
copy retained this directory and the app build failed while signing:

```text
App.app/Contents/ReexportedBinaries/GRDBSQLite.framework:
unsealed contents present in the root directory of an embedded framework
Command CodeSign failed with a nonzero exit code
```
