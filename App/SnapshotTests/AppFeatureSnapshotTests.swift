import AppFeature
import ComposableArchitecture
import Model
import PlanFeature
import SnapshotTesting
import SwiftUI
import XCTest

class AppFeatureSnapshotTests: XCTestCase {
	let xcodeCloudPath: StaticString =
		"/Volumes/workspace/repository/ci_scripts/AppFeatureSnapshotTests.swift"

	func testAppSnapshot() {
		withDependencies {
			$0.groceryStoresClient = .mock
			$0.shoppingListClient = .mock
			$0.uuid = .incrementing
		} operation: {
			let view = AppView(
				store: Store(
					initialState: AppFeature.State()
				) {
					AppFeature()
				}
			)
			//isRecording = true
			assertStandardSnapshots(
				content: view,
				named: "App Feature",
				throwaway: .data,
				xcodeCloudFilePath: xcodeCloudPath
			)

			//      assertSnapshot(of: view, as: .tree)
		}
	}
}

extension Snapshotting where Value: SwiftUI.View, Format == String {
}
