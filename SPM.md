# Swift Package Manager

GEOSwift supports SPM on macOS & Linux.

SPM's [System Library Targets](https://github.com/apple/swift-evolution/blob/master/proposals/0208-package-manager-system-library-targets.md) allows linking against any library installed on the machine.

1. Ensure that the geos package is installed on your machine. For Mac, Homebrew is suggested: `$ brew install geos`
2. Update `Package.swift` to include GEOSwift as a dependency:

```swift
// swift-tools-version:5.0
let package = Package(
  name: "your-package-name",
  dependencies: [
    .package(url: "https://github.com/GEOSwift/GEOSwift.git", from: "x.x.x") // Recommend latest release version, e.g. "5.2.0"
  ],
  targets: [
    .target("your-target-name", dependencies: ["GEOSwift"])
  ]
)
```

3.  Ensure that your system has a pkg-config file available for `libgeos_c`:
```
$ pkg-config --validate geos_c
```
> NOTE: Homebrew's current version of geos does not seem to generate a `.pc` file on install.  See the next section for options.

## Providing geos_c library location under Homebrew

Because Homebrew does not generate a pkg-config file for geos, one is provided in this repository: [geos_c.pc](CLibGeosC/geos_c.pc).  You can choose to install it manually, amend your PKG_CONFIG_PATH, or provide the search paths to swiftc by hand.

* Option 1: Copy the sample pkg-config file to your system:
```
$ cp CLibGeosC/geos_c.pc /usr/local/lib/pkgconfig/
$ pkg-config --validate geos_c # should return 0
```

* Option 2: Amend the PKG_CONFIG_PATH to allow pkg-config to find the configuration file:
```
$ export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:/path/to/GEOSwift/CLibGeosC
$ pkg-config --validate geos_c # should succeed with no error
```

* Option 3: Pass the homebrew paths for geos to swift build every time (you may want to put this into a Makefile):
```
$ swift build -Xlinker \
              -L$(brew --prefix geos)/lib \
              -Xcc \
              -I$(brew --prefix geos)/include
```
