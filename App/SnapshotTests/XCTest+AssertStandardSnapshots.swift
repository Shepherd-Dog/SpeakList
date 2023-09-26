import AccessibilitySnapshot
import SnapshotTesting
import SwiftUI
import XCTest

extension Snapshotting where Value == UIViewController, Format == UIImage {
  fileprivate static func standardImage(on viewImageConfig: ViewImageConfig) -> Snapshotting {
    .image(
      drawHierarchyInKeyWindow: true,
      precision: 0.995,
      perceptualPrecision: 0.98,
      size: viewImageConfig.size
    )
//    .image(
//      on: viewImageConfig,
////      precision: 0.985,
//      precision: 1.0,
//      perceptualPrecision: 1.0
//    )
  }

  fileprivate static func standardVoiceOverAccessibilityImage(on viewImageConfig: ViewImageConfig) -> Snapshotting {
    .impreciseAccessibilityImage(
      drawHierarchyInKeyWindow: true,
      precision: 0.995,
      perceptualPrecision: 0.98
    )
//    .accessibilityImage(drawHierarchyInKeyWindow: true)
  }
}

extension XCTest {
  // https://github.com/pointfreeco/swift-snapshot-testing/discussions/553#discussioncomment-3807207
  private static var xcodeCloudFilePath: StaticString {
    "/Volumes/workspace/repository/ci_scripts/SnapshotTests.swift"
  }

  private static var isCIEnvironment: Bool {
    ProcessInfo.processInfo.environment["CI"] == "TRUE"
  }

  /// Creates snapshots in a variety of different environments at the screen size of an iPhone 13 Pro.
  /// This method must be called when running tests on a device or simulator with the proper display scale
  /// and OS version.
  ///
  /// Environments used for these snapshots:
  /// * Light Mode
  /// * Dark Mode
  /// * All Dynamic Type Sizes
  ///
  /// - Parameters:
  ///   - view: The SwiftUI `View` to snapshot.
  ///   - createThrowaway: Create 1px by 1px "throwaway" image to allow dependencies time to get
  ///   setup.
  ///   - snapshotDeviceModelName: The device model name used when recording snapshots.
  ///   Defaults to `"iPhone 15 Pro"`. The test will fail if snapshots are recorded with a different
  ///   device.
  ///   - snapshotDeviceScale: The device scale used when recorded snapshots. Defaults to 3.0.
  ///   The test will fail if snapshots are recorded with a different scale.
  ///   - snapshotDeviceOSVersions: A dictionary of the OS versions used for snapshots. Defaults
  ///   to: ["iOS": 17.0, "macOS": 14.0, "tvOS": 17.0, "visionOS": 1.0, "watchOS": 10.0]. The test will fail
  ///   if snapshots are recorded with a different version.
  ///   - viewImageConfig: The `ViewImageConfig` for the snapshot.
  ///   - xcodeCloudFilePath: A `StaticString` describing the path that will be used when
  ///   running these tests on Xcode Cloud. Defaults to `"/Volumes/workspace/repository/ci_scripts/SnapshotTests.swift"`. If your
  ///   tests are in a Swift file with a name other than "SnapshotTests.swift" you will need to provide this
  ///   same `StaticString` but with your test file's name in place of "SnapshotTests.swift".
  ///   - file: The file in which failure occurred. Defaults to the file name of the test case in which this function was called.
  ///   - testName: The name of the test in which failure occurred. Defaults to the function name of the test case in which this function was called.
  ///   - line: The line number on which failure occurred. Defaults to the line number on which this function was called.
  func assertStandardSnapshots(
    view: some View,
    createThrowaway: Bool = false,
    snapshotDeviceModelName: String = "iPhone 15 Pro",
    snapshotDeviceOSVersions: [String: Double] = [
      "iOS": 17.0,
      "macOS": 14.0,
      "tvOS": 17.0,
      "visionOS": 1.0,
      "watchOS": 10.0
    ],
    snapshotDeviceScale: CGFloat = 3,
    viewImageConfig: ViewImageConfig = .iPhone13Pro,
    xcodeCloudFilePath: StaticString = xcodeCloudFilePath,
    file: StaticString = #file,
    testName: String = #function,
    line: UInt = #line
  ) {
    guard UIDevice.modelName == snapshotDeviceModelName else {
      XCTFail(
        "Running in a \(UIDevice.modelName) simulator instead of the required \(snapshotDeviceModelName) simulator.",
        file: file,
        line: line
      )
      return

    }
    guard UIScreen.main.scale == snapshotDeviceScale else {
      XCTFail(
        "Running in simulator with @\(UIScreen.main.scale)x scale instead of the required @\(snapshotDeviceScale)x scale.",
        file: file,
        line: line
      )
      return
    }
    let snapshotDeviceOSVersion: String
    #if os(iOS)
    guard let version = snapshotDeviceOSVersions["iOS"] else {
      XCTFail(
        "iOS version not provided.",
        file: file,
        line: line
      )
      return
    }
    snapshotDeviceOSVersion = "\(version)"
    #elseif os(macOS)
    guard let version = snapshotDeviceOSVersions["macOS"] else {
      XCTFail(
        "macOS version not provided.",
        file: file,
        line: line
      )
      return
    }
    snapshotDeviceOSVersion = "\(version)"
    #elseif os(tvOS)
    guard let version = snapshotDeviceOSVersions["tvOS"] else {
      XCTFail(
        "tvOS version not provided.",
        file: file,
        line: line
      )
      return
    }
    snapshotDeviceOSVersion = "\(version)"
    #elseif os(visionOS)
    guard let version = snapshotDeviceOSVersions["visionOS"] else {
      XCTFail(
        "visionOS version not provided.",
        file: file,
        line: line
      )
      return
    }
    snapshotDeviceOSVersion = "\(version)"
    #elseif os(watchOS)
    guard let version = snapshotDeviceOSVersions["watchOS"] else {
      XCTFail(
        "watchOS version not provided.",
        file: file,
        line: line
      )
      return
    }
    snapshotDeviceOSVersion = "\(version)"
    #endif
    guard UIDevice.current.systemVersion == "\(snapshotDeviceOSVersion)" else {
      XCTFail(
        "Running with OS version \(UIDevice.current.systemVersion) instead of the required OS version \(snapshotDeviceOSVersion).",
        file: file,
        line: line
      )
      return
    }

    let filePath: StaticString

    if Self.isCIEnvironment {
      filePath = xcodeCloudFilePath
    } else {
      filePath = file
    }

    if createThrowaway {
      let viewController = UIHostingController(
        rootView: view
          .transaction {
            $0.disablesAnimations = true
          }
      )

      let screenScale = max(1, UIScreen.main.scale)

      assertSnapshot(
        matching: viewController,
        as: .standardImage(
          on: ViewImageConfig(
            size: CGSize(
              width: 1/screenScale,
              height: 1/screenScale
            )
          )
        ),
        named: "\(name) - Throwaway",
        file: filePath,
        testName: testName,
        line: line
      )
    }

    for colorScheme in ColorScheme.allCases {
      let viewController = UIHostingController(
        rootView: view
          .transaction {
            $0.disablesAnimations = true
          }
          .background(colorScheme == .light ? Color.white : Color.black)
          .environment(\.colorScheme, colorScheme)
      )
      viewController.view.backgroundColor = colorScheme == .light ? .white : .black

      assertSnapshot(
        matching: viewController,
        as: .wait(for: 0.1, on: .standardImage(on: viewImageConfig)),
        named: "\(name) - Color Scheme: \(colorScheme)",
        file: filePath,
        testName: testName,
        line: line
      )
    }

    for size in DynamicTypeSize.allCases {
      let viewController = UIHostingController(
        rootView: view
          .transaction {
            $0.disablesAnimations = true
          }
          .environment(\.dynamicTypeSize, size)
      )

      assertSnapshot(
        matching: viewController,
        as: .wait(for: 0.1, on: .standardImage(on: viewImageConfig)),
        named: "\(name) - Dynamic Type: \(size)",
        file: filePath,
        testName: testName,
        line: line
      )
    }

    do {
      let viewController = UIHostingController(
        rootView: view
          .transaction {
            $0.disablesAnimations = true
          }
      )
      viewController.view.frame = UIScreen.main.bounds

      assertSnapshot(
        matching: viewController,
        as: .wait(for: 0.1, on: .standardVoiceOverAccessibilityImage(on: viewImageConfig)),
        named: "\(name) - VoiceOver Accessibility",
        file: filePath,
        testName: testName,
        line: line
      )
    }
  }
}
