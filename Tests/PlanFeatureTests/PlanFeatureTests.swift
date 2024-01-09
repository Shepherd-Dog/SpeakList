import ComposableArchitecture
import ItemFormFeature
import Model
import PlanFeature
import XCTest

@MainActor
class PlanFeatureTests: XCTestCase {
	func testBasics() async {
		let store = TestStore(
			initialState: PlanFeature.State()
		) {
			PlanFeature()
		} withDependencies: {
			$0.groceryStoresClient.fetchGroceryStores = {
				.mocks
			}
			$0.shoppingListClient = .mock
			$0.uuid = .incrementing
		}

		await store.send(.onAppear)

		await store.receive(
			.didReceiveGroceryStores(
				.mocks
			)
		) {
			$0.stores = .mocks
		}
		await store.receive(
			.didReceiveShoppingList(
				.mocks
			)
		) {
			$0.items = .mocks
		}

		XCTAssertNoDifference(
			[
				GroupedListItem(
					name: "Kroger",
					items: [
						.mockPeanutButter
					]
				),
				GroupedListItem(
					name: "Natural Grocers",
					items: [
						.mockProteinPowder
					]
				),
				GroupedListItem(
					name: "Sprouts",
					items: [
						.mockBananas,
						.mockApples,
					]
				),
			],
			store.state.groupedItems
		)

		await store.receive(.showList) {
			$0.showList = true
		}

		await store.send(
			.didTapEditItem(
				ListItem(
					id: UUID(711),
					name: "Apples",
					checked: false
				)
			)
		) {
			$0.editItem = ItemFormFeature.State(
				item: ListItem(
					id: UUID(711),
					name: "Apples",
					checked: false
				),
				stores: .mocks
			)
		}

		await store.send(.editItem(.presented(.didEditItemName("Organic Apples")))) {
			$0.editItem?.item.name = "Organic Apples"
		}

		await store.send(
			.editItem(
				.presented(
					.didEditPreferredStore(
						GroceryStore.mockSprouts.id
					)
				)
			)
		) {
			$0.editItem?.item.preferredStoreLocation = GroceryStoreLocation(
				id: UUID(1),
				location: .unknown,
				storeID: GroceryStore.mockSprouts.id
			)
		}

		await store.send(
			.editItem(
				.presented(
					.didEditPreferredStoreLocation(.produce)
				)
			)
		) {
			$0.editItem?.item.preferredStoreLocation.location = .produce
		}

		await store.send(.didCompleteEditItem) {
			$0.editItem = nil
			$0.items[id: UUID(711)] = ListItem(
				id: UUID(711),
				name: "Organic Apples",
				checked: false,
				preferredStoreLocation: GroceryStoreLocation(
					id: UUID(1),
					location: .produce,
					storeID: GroceryStore.mockSprouts.id
				)
			)
		}

		XCTAssertNoDifference(
			[
				GroupedListItem(
					name: "Kroger",
					items: [
						.mockPeanutButter
					]
				),
				GroupedListItem(
					name: "Natural Grocers",
					items: [
						.mockProteinPowder
					]
				),
				GroupedListItem(
					name: "Sprouts",
					items: [
						.mockBananas,
						ListItem(
							id: UUID(711),
							name: "Organic Apples",
							checked: false,
							preferredStoreLocation:
								GroceryStoreLocation(
									id: UUID(1),
									location: .produce,
									storeID: GroceryStore
										.mockSprouts.id
								)
						),
					]
				),
			],
			store.state.groupedItems
		)

		await store.send(.onDelete("Sprouts", IndexSet(integer: 1))) {
			$0.items.remove(id: UUID(711))
		}
	}
}
