import DesignSystem
import SnapshotTesting
import SwiftUI
import XCTest

class DesignSystemTests: XCTestCase {
  func testTextFieldSnapshotColorScheme() {
    for colorScheme in ColorScheme.allCases {
      let view = DesignSystem.TextField("Name", text: .constant("Tigger"))
        .background(colorScheme == .light ? Color.white : Color.black)
        .environment(\.colorScheme, colorScheme)
      let viewController = UIHostingController(rootView: view)
      viewController.view.backgroundColor = colorScheme == .light ? .white : .black

      assertSnapshot(
        matching: viewController,
        as: .image(on: .iPhone13Pro),
        named: "Color Scheme: \(colorScheme)"
      )
    }
  }

  func testTextFieldSnapshotDynamicType() {
    for size in DynamicTypeSize.allCases {
      let view = DesignSystem.TextField("Name", text: .constant("Tigger"))
        .environment(\.dynamicTypeSize, size)
      let viewController = UIHostingController(rootView: view)

      assertSnapshot(
        matching: viewController,
        as: .image(on: .iPhone13Pro),
        named: "Dynamic Type: \(size)"
      )
    }
  }
}
