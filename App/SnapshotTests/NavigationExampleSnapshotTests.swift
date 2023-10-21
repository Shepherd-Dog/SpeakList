import AccessibilitySnapshot
import SnapshotTesting
import SwiftUI
import XCTest

class NavigationExampleSnapshotTests: XCTestCase {
  func testNavigationView() {
    let view = NavigationView {
      Text("Text inside a NavigationView")
        .navigationTitle("Navigation View")
        .toolbar {
          ToolbarItem {
            Button {
              // no-op
            } label: {
              Text("Add")
            }
          }
        }
    }

    let hostingController = UIHostingController(rootView: view)
    hostingController.view.frame = UIScreen.main.bounds

    assertSnapshot(
      of: hostingController,
      as: .accessibilityImage(drawHierarchyInKeyWindow: true)
    )
  }

  func testNavigationStack() {
    let view = NavigationStack {
      Text("Text inside a NavigationStack")
        .navigationTitle("Navigation Stack")
        .toolbar {
          ToolbarItem {
            Button {
              // no-op
            } label: {
              Text("Add")
            }
          }
        }
    }

    let hostingController = UIHostingController(rootView: view)
    hostingController.view.frame = UIScreen.main.bounds

    assertSnapshot(
      of: hostingController,
      as: .accessibilityImage(drawHierarchyInKeyWindow: true)
    )
  }
}
