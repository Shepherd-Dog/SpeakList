import DesignSystem
import OSLog
import SwiftUI
import XCTest

extension Logger {
    /// Using your bundle identifier is a great way to ensure a unique identifier.
    private static var subsystem = Bundle.main.bundleIdentifier!

    /// Logs from tests..
    static let tests = Logger(subsystem: subsystem, category: "Tests")
}

class DesignSystemTests: XCTestCase {
  func testTextFieldSnapshot() {
    let view = DesignSystem.TextField("Name", text: .constant("Tigger"))

    snapshotDefaultPresentations(
      view: view
    )
  }
}
