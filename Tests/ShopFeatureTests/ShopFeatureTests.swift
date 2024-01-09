import ComposableArchitecture
import Model
import ShopFeature
import XCTest

@MainActor
class ShopFeatureTests: XCTestCase {
	func testBasics() async {
		let store = TestStore(
			initialState: ShopFeature.State()
		) {
			ShopFeature()
		} withDependencies: {
			$0.uuid = .incrementing
		}

		let sprouts = GroceryStore.mockSprouts

		var groceryStores: IdentifiedArrayOf<GroceryStore> = []
		var shoppingList: IdentifiedArrayOf<ListItem> = []

		withDependencies {
			$0.uuid = .incrementing
		} operation: {
			shoppingList = [
				ListItem(
					id: UUID(0),
					name: "Apples",
					checked: false,
					preferredStoreLocation: GroceryStoreLocation(
						id: UUID(0),
						location: .produce,
						storeID: sprouts.id
					)
				),
				ListItem(
					id: UUID(1),
					name: "Bananas",
					checked: false,
					preferredStoreLocation: GroceryStoreLocation(
						id: UUID(0),
						location: .produce,
						storeID: sprouts.id
					)
				),
				ListItem(
					id: UUID(2),
					name: "Water",
					checked: false,
					preferredStoreLocation: GroceryStoreLocation(
						id: UUID(0),
						location: .aisle("13C"),
						storeID: sprouts.id
					)
				),
			]

			groceryStores = [
				sprouts
			]
		}

		await store.send(
			.didReceiveShoppingList(shoppingList, groceryStores)
		) {
			$0.trips = IdentifiedArrayOf<ShoppingTrip>(
				uniqueElements: [
					ShoppingTrip(
						id: UUID(0),
						store: sprouts,
						groups: IdentifiedArrayOf<GroupedListItem>(
							uniqueElements: [
								GroupedListItem(
									name: "Aisle 13C",
									items: IdentifiedArrayOf<
										ListItem
									>(
										uniqueElements: [
											ListItem(
												id:
													UUID(
														2
													),
												name:
													"Water",
												checked:
													false,
												preferredStoreLocation:
													GroceryStoreLocation(
														id:
															UUID(
																0
															),
														location:
															.aisle(
																"13C"
															),
														storeID:
															sprouts
															.id
													)
											)
										]
									)
								),
								GroupedListItem(
									name: "Produce",
									items: IdentifiedArrayOf<
										ListItem
									>(
										uniqueElements: [
											ListItem(
												id:
													UUID(
														0
													),
												name:
													"Apples",
												checked:
													false,
												preferredStoreLocation:
													GroceryStoreLocation(
														id:
															UUID(
																0
															),
														location:
															.produce,
														storeID:
															sprouts
															.id
													)
											),
											ListItem(
												id:
													UUID(
														1
													),
												name:
													"Bananas",
												checked:
													false,
												preferredStoreLocation:
													GroceryStoreLocation(
														id:
															UUID(
																0
															),
														location:
															.produce,
														storeID:
															sprouts
															.id
													)
											),
										]
									)
								),
							]
						)
					)
				]
			)
			XCTAssertEqual($0.trips.first?.allItems.count, 3)
		}
	}
}
