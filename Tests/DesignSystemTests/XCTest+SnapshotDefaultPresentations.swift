import SnapshotTesting
import SwiftUI
import XCTest

extension XCTest {
  // https://github.com/pointfreeco/swift-snapshot-testing/discussions/553#discussioncomment-3807207
  var ciPath: StaticString {
    "/Volumes/workspace/repository/ci_scripts/DesignSystemTests.swift"
  }
  var isCIEnvironment: Bool {
    ProcessInfo.processInfo.environment["CI"] == "TRUE"
  }

  func snapshotDefaultPresentations(
    view: some View,
    file: StaticString = #file,
    testName: String = #function,
    line: UInt = #line
  ) {
    for colorScheme in ColorScheme.allCases {
      let viewController = UIHostingController(
        rootView: view
          .background(colorScheme == .light ? Color.white : Color.black)
          .environment(\.colorScheme, colorScheme)
      )
      viewController.view.backgroundColor = colorScheme == .light ? .white : .black

      var filePath: StaticString

      if isCIEnvironment {
        filePath = ciPath
      } else {
        filePath = file
      }

      assertSnapshot(
        matching: viewController,
        as: .image(on: .iPhone13Pro),
        named: "Color Scheme: \(colorScheme)",
        file: filePath,
        testName: testName,
        line: line
      )
    }

    for size in DynamicTypeSize.allCases {
      let viewController = UIHostingController(
        rootView: view
          .environment(\.dynamicTypeSize, size)
      )

      var filePath: StaticString

      if isCIEnvironment {
        filePath = ciPath
      } else {
        filePath = file
      }

      assertSnapshot(
        matching: viewController,
        as: .image(on: .iPhone13Pro),
        named: "Dynamic Type: \(size)",
        file: filePath,
        testName: testName,
        line: line
      )
    }
  }
}
