import DesignSystem
import OSLog
import SnapshotTesting
import SwiftUI
import XCTest

extension Logger {
    /// Using your bundle identifier is a great way to ensure a unique identifier.
    private static var subsystem = Bundle.main.bundleIdentifier!

    /// Logs from tests..
    static let tests = Logger(subsystem: subsystem, category: "Tests")
}

class DesignSystemTests: XCTestCase {
  // https://github.com/pointfreeco/swift-snapshot-testing/discussions/553#discussioncomment-3807207
  let ciPath: StaticString = "/Volumes/workspace/repository/ci_scripts/DesignSystemTests.swift"
  let localPath: StaticString = #file
  var isCIEnvironment: Bool {
    Logger.tests.error("Current directory path: \(FileManager.default.currentDirectoryPath)")

    return FileManager.default.currentDirectoryPath.contains("/Volumes/workspace")
//    ProcessInfo.processInfo.environment["CI"] == "TRUE"
  }

  func testTextFieldSnapshotColorScheme() {
    for colorScheme in ColorScheme.allCases {
      let view = DesignSystem.TextField("Name", text: .constant("Tigger"))
        .background(colorScheme == .light ? Color.white : Color.black)
        .environment(\.colorScheme, colorScheme)
      let viewController = UIHostingController(rootView: view)
      viewController.view.backgroundColor = colorScheme == .light ? .white : .black

      var filePath: StaticString

      if isCIEnvironment {
        filePath = ciPath
      } else {
        filePath = localPath
      }

      assertSnapshot(
        matching: viewController,
        as: .image(on: .iPhone13Pro),
        named: "Color Scheme: \(colorScheme)",
        file: filePath
      )
    }
  }

  func testTextFieldSnapshotDynamicType() {
    for size in DynamicTypeSize.allCases {
      let view = DesignSystem.TextField("Name", text: .constant("Tigger"))
        .environment(\.dynamicTypeSize, size)
      let viewController = UIHostingController(rootView: view)

      var filePath: StaticString

      if isCIEnvironment {
        filePath = ciPath
      } else {
        filePath = localPath
      }

      assertSnapshot(
        matching: viewController,
        as: .image(on: .iPhone13Pro),
        named: "Dynamic Type: \(size)",
        file: filePath
      )
    }
  }
}
