import ComposableArchitecture
import Model
import PlanFeature
import SwiftUI
import XCTest

class PlanFeatureSnapshotTests: XCTestCase {
	let xcodeCloudPath: StaticString =
		"/Volumes/workspace/repository/ci_scripts/PlanFeatureSnapshotTests.swift"

	func testListSnapshot() {
		withDependencies {
			$0.groceryStoresClient = .mock
			$0.shoppingListClient = .mock
			$0.uuid = .incrementing
		} operation: {
			let view = NavigationStack {
				PlanView(
					store: Store(
						initialState: PlanFeature.State()
					) {
						PlanFeature()
					}
				)
			}

			assertStandardSnapshots(
				content: view,
				named: "Plan Feature",
				throwaway: .data,
				xcodeCloudFilePath: xcodeCloudPath
			)
		}
	}
}
