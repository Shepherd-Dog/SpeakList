import AccessibilitySnapshot
import SnapshotTesting
import SwiftUI
import XCTest

enum Throwaway {
  case data
  case image
}

extension Snapshotting where Value == UIViewController, Format == UIImage {
  fileprivate static func standardImage(
    on viewImageConfig: ViewImageConfig,
    perceptualPrecision: Float = 0.98,
    precision: Float = 0.995
  ) -> Snapshotting {
    .image(
      drawHierarchyInKeyWindow: true,
      precision: precision,
      perceptualPrecision: perceptualPrecision,
      size: viewImageConfig.size
    )
  }

  fileprivate static func standardVoiceOverAccessibilityImage(on viewImageConfig: ViewImageConfig) -> Snapshotting {
    .impreciseAccessibilityImage(
      drawHierarchyInKeyWindow: true,
      precision: 0.995,
      perceptualPrecision: 0.98
    )
  }
}

extension XCTest {
  // https://github.com/pointfreeco/swift-snapshot-testing/discussions/553#discussioncomment-3807207
  private static var xcodeCloudFilePath: StaticString {
    "/Volumes/workspace/repository/ci_scripts/SnapshotTests.swift"
  }

  static var isCIEnvironment: Bool {
    ProcessInfo.processInfo.environment["CI"] == "TRUE"
  }

  /// Creates snapshots in a variety of different environments at the screen size of an iPhone SE (by
  /// default).
  /// This method ensures that tests are running on a the proper device or simulator
  /// and OS version.
  ///
  /// Environments used for these snapshots:
  /// * Light Mode
  /// * Dark Mode
  /// * All Dynamic Type Sizes
  /// * VoiceOver Accessibility
  ///
  /// - Parameters:
  ///   - view: The SwiftUI `View` to snapshot.
  ///   - createThrowaway: Create 1px by 1px "throwaway" image to allow dependencies time to get
  ///   setup. Defaults to `false`.
  ///   - snapshotDeviceModelName: The device model name used when recording snapshots.
  ///   Defaults to `"iPhone 15 Pro"`. The test will fail if snapshots are recorded with a different
  ///   device.
  ///   - snapshotDeviceOSVersions: A dictionary of the OS versions used for snapshots. Defaults
  ///   to: ["iOS": "17.0.1", "macOS": "14.0", "tvOS": "17.0", "visionOS": "1.0", "watchOS": "10.0"]. The test will fail
  ///   if snapshots are recorded with a different version.
  ///   - viewImageConfig: The `ViewImageConfig` for the snapshot which will determine the size of the rendered snapshot.
  ///   Defaults to `.iPhoneSe`.
  ///   - xcodeCloudFilePath: A `StaticString` describing the path that will be used when
  ///   running these tests on Xcode Cloud. Defaults to `"/Volumes/workspace/repository/ci_scripts/SnapshotTests.swift"`. If your
  ///   tests are in a Swift file with a name other than "SnapshotTests.swift" you will need to provide this
  ///   same `StaticString` but with your test file's name in place of "SnapshotTests.swift".
  ///   - file: The file in which failure occurred. Defaults to the file name of the test case in which this function was called.
  ///   - testName: The name of the test in which failure occurred. Defaults to the function name of the test case in which this function was called.
  ///   - line: The line number on which failure occurred. Defaults to the line number on which this function was called.
  func assertStandardSnapshots(
    content: some View,
    named name: String,
    throwaway: Throwaway? = nil,
    snapshotDeviceModelName: String = "iPhone 15 Pro",
    snapshotDeviceOSVersions: [String: String] = [
      "iOS": "17.0.1",
      "macOS": "14.0",
      "tvOS": "17.0",
      "visionOS": "1.0",
      "watchOS": "10.0"
    ],
    viewImageConfig: ViewImageConfig = .iPhoneSe,
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

    if Locale.preferredLanguages.first != "en-US" 
        && Locale.preferredLanguages.first != "en" {
      XCTFail(
        """
        Running on a simulator with its first preferred language set to \
        something other than English (US) may cause the snapshots to be rendered \
        differently. Please set English (US) as the simulator's first preferred \
        language (Settings > General > Language & Region). First preferred \
        language: \(Locale.preferredLanguages.first ?? "Unknown")
        """,
        file: file,
        line: line
      )
      return
    }

    if Locale.preferredLanguages.contains(where: {
      $0.contains("ar") || $0.contains("hy")
    }) {
      XCTFail(
        """
        Running on a simulator with Arabic or Armenian in its preferred \
        languages which will cause the snapshots to be rendered differently. \
        Please remove Arabic and/or Armenian from the simulator's preferred \
        languages (Settings > General > Language & Region).
        """,
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

    if let throwaway {
      let viewController = UIHostingController(
        rootView: content
          .transaction { $0.animation = nil }
      )
      
      let size: CGSize

      switch throwaway {
      case .data:
        let screenScale = max(1, UIScreen.main.scale)

        size = CGSize(
          width: 1/screenScale,
          height: 1/screenScale
        )
      case .image:
        size = viewImageConfig.size ?? .init(width: 0, height: 0)
      }

      assertSnapshot(
        matching: viewController,
        as: .standardImage(
          on: ViewImageConfig(
            size: size
          ),
          perceptualPrecision: 0.0,
          precision: 0.0
        ),
        named: "\(name) - Throwaway",
        file: filePath,
        testName: testName,
        line: line
      )
    }

    for colorScheme in ColorScheme.allCases {
      let viewController = UIHostingController(
        rootView: content
          .transaction { $0.animation = nil }
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
        rootView: content
          .transaction { $0.animation = nil }
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
        rootView: content
          .transaction { $0.animation = nil }
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
