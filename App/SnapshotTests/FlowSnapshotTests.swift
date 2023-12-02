import AppFeature
import ComposableArchitecture
import SnapshotTesting
import XCTest

extension XCTest {
  @MainActor
  static func snapshotImage(
    overrideUserInterfaceStyle: UIUserInterfaceStyle,
    perceptualPrecision: Float = 0.98,
    precision: Float = 0.995
  ) -> Snapshotting<UIViewController, UIImage> {
    return .windowedImage(
      precision: precision,
      perceptualPrecision: perceptualPrecision,
      overrideUserInterfaceStyle: overrideUserInterfaceStyle
    )
  }
}

extension Snapshotting where Value: UIViewController, Format == UIImage {
  @MainActor
  static func windowedImage(
    precision: Float,
    perceptualPrecision: Float,
    overrideUserInterfaceStyle: UIUserInterfaceStyle
  ) -> Snapshotting {
    SimplySnapshotting.image(
      precision: precision,
      perceptualPrecision: perceptualPrecision
    ).asyncPullback { viewController in
      Async<UIImage> { callback in
        // Hide carets in text fields
        UITextField.appearance().tintColor = .clear

        guard let window = UIApplication
          .shared
          .connectedScenes
          .compactMap(
            { scene in
              (scene as? UIWindowScene)?.keyWindow
            }
          )
          .first
        else {
          fatalError("Cannot find key window")
        }

        // Try to speed up animations
        window.layer.speed = 1000
        window.overrideUserInterfaceStyle = overrideUserInterfaceStyle

        window.rootViewController = viewController

        let image = UIGraphicsImageRenderer(bounds: window.bounds).image { _ in
          window.drawHierarchy(in: window.bounds, afterScreenUpdates: true)
        }

        callback(image)
      }
    }
  }
}

@MainActor
class FlowSnapshotTests: XCTestCase {
  let xcodeCloudPath: StaticString = "/Volumes/workspace/repository/ci_scripts/FlowSnapshotTests.swift"

  func testHappyPath() async throws {
    let store = Store(
      initialState: AppFeature.State()
    ) {
      AppFeature()
        .dependency(\.groceryStoresClient, .mock)
        .dependency(\.shoppingListClient, .mock)
        .dependency(\.uuid, .incrementing)
    }

    let view = AppView(
      store: store
    )

    let flowActions: [FlowRunner.NamedAction<AppFeature.Action>] = [
      .init(
        name: "Tap on Add Item",
        action: .listFeature(.didTapAddItem)
      ),
      .init(
        name: "Cancel adding item", 
        action: .listFeature(.didCancelAddItem)
      ),
      .init(
        name: "Add Item to Plan", 
        action: .listFeature(.didTapAddItem)
      ),
      .init(
        name: "Edit Item Name", 
        action: .listFeature(.addItem(.presented(.didEditItemName("Juicy Fruit"))))
      ),
      .init(
        name: "Save New Item", 
        action: .listFeature(.didCompleteAddItem)
      ),
    ]

    try await FlowRunner.run(
      type: "Happy Path",
      store: store,
      initialView: view,
      initializationAction: .init(
        name: "Initialization",
        action: .listFeature(.onAppear)
      ),
      actions: flowActions,
      configurations: [
        .init(name: "Light Mode")
      ]
    ) { viewController, uiUserInterfaceStyle, name in
      let filePath: StaticString

      if Self.isCIEnvironment {
        filePath = self.xcodeCloudPath
      } else {
        filePath = #file
      }

      if name.contains("Throwaway") {
        assertSnapshot(
          matching: viewController,
          as: Self.snapshotImage(
              overrideUserInterfaceStyle: uiUserInterfaceStyle,
              perceptualPrecision: 0,
              precision: 0
          ),
          named: name,
          file: filePath
        )
      } else {
        assertSnapshot(
          matching: viewController,
          as: .wait(
            for: 0.1,
            on: Self.snapshotImage(
              overrideUserInterfaceStyle: uiUserInterfaceStyle
            )
          ),
          named: name,
          file: filePath
        )
      }
    }
  }
}
