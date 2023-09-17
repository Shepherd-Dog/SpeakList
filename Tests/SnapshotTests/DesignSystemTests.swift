import DesignSystem
import OSLog
import SwiftUI
import XCTest

extension Logger {
    /// Using your bundle identifier is a great way to ensure a unique identifier.
    private static var subsystem = Bundle.main.bundleIdentifier!

    /// Logs from tests.
    static let tests = Logger(subsystem: subsystem, category: "Tests")
}

class DesignSystemTests: XCTestCase {
  let xcodeCloudPath: StaticString = "/Volumes/workspace/repository/ci_scripts/DesignSystemTests.swift"

  func testTextFieldSnapshot() {
    let view = DesignSystem.TextField("Name", text: .constant("Tigger"))

    assertStandardSnapshots(
      view: view,
      xcodeCloudFilePath: xcodeCloudPath
    )
  }
}
