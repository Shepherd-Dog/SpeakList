import ComposableArchitecture
import GroceryStoresClient
import Model
import StoresFeature
import XCTest

@MainActor
class StoresFeatureTests: XCTestCase {
	func testBasics() async {
		let store = TestStore(
			initialState: StoresFeature.State()
		) {
			StoresFeature()
		} withDependencies: {
			$0.groceryStoresClient = GroceryStoresClient.mock
			$0.uuid = .incrementing
		}

		await store.send(.onAppear)

		await store.receive(
			.didReceiveGroceryStores(
				.mocksWithTypoInSprouts
			)
		) {
			$0.stores = .mocksWithTypoInSprouts
		}

		await store.send(.addStoreButtonTapped) {
			$0.addStore = StoreFormFeature.State(
				groceryStore: GroceryStore(id: UUID(0), name: ""))
		}

		await store.send(.addStore(.presented(.didEditStoreName("Albertsons")))) {
			$0.addStore = StoreFormFeature.State(
				groceryStore: GroceryStore(id: UUID(0), name: "Albertsons"))
		}

		await store.send(.didCompleteAddStore) {
			$0.addStore = nil
			$0.stores[3] = GroceryStore(id: UUID(0), name: "Albertsons")
		}

		await store.send(.editStoreButtonTapped(store.state.stores[0])) {
			$0.editStore = StoreFormFeature.State(groceryStore: store.state.stores[0])
		}

		await store.send(.editStore(.presented(.didEditStoreName("Sprouts")))) {
			$0.editStore?.groceryStore.name = "Sprouts"
		}

		await store.send(.editStore(.presented(.onMove([2], 0)))) {
			$0.editStore?.groceryStore.locationsOrder = [
				.produce,
				.aisle,
				.dairy,
				.unknown,
			]
		}

		await store.send(.didCompleteEditStore) {
			$0.stores[0] = $0.editStore!.groceryStore
			$0.editStore = nil
		}

		await store.send(.addStoreButtonTapped) {
			$0.addStore = StoreFormFeature.State(
				groceryStore: GroceryStore(id: UUID(1), name: ""))
		}

		await store.send(.didCancelAddStore) {
			$0.addStore = nil
		}

		await store.send(.editStoreButtonTapped(store.state.stores[1])) {
			$0.editStore = StoreFormFeature.State(groceryStore: store.state.stores[1])
		}

		await store.send(.didCancelEditStore) {
			$0.editStore = nil
		}
	}
}
