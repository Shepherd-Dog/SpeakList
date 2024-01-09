import ComposableArchitecture
import Foundation
import GroceryStoresClient
import Model
import ShoppingListClient
import ShoppingTripFeature

@Reducer
public struct ShopFeature {
	@ObservableState
	public struct State: Equatable {
		@Presents var shoppingTripFeature: ShoppingTripFeature.State?
		public var trips: IdentifiedArrayOf<ShoppingTrip> = []

		public init(trips: IdentifiedArrayOf<ShoppingTrip> = []) {
			self.trips = trips
		}
	}

	public enum Action: Equatable {
		case didReceiveShoppingList(
			IdentifiedArrayOf<ListItem>, IdentifiedArrayOf<GroceryStore>)
		case didTapShoppingTrip(ShoppingTrip)
		case onAppear
		case shoppingTripFeature(PresentationAction<ShoppingTripFeature.Action>)
	}

	@Dependency(\.groceryStoresClient) var groceryStoresClient
	@Dependency(\.mainQueue) var mainQueue
	@Dependency(\.shoppingListClient) var shoppingListClient

	public init() {}

	public var body: some ReducerOf<Self> {
		Reduce { state, action in
			switch action {
			case let .didReceiveShoppingList(items, honestStores):
				state.trips = items.reduce(
					[],
					{ partialResult, item in
						var updatedResult = partialResult
						guard
							let itemStoreID = item
								.preferredStoreLocation
								.storeID
						else {
							return updatedResult
						}
						guard let store = honestStores[id: itemStoreID]
						else {
							return []
						}
						let groupName = item.preferredStoreLocation.location
							.name

						if let existingTrip = partialResult.first(where: {
							$0.store == store
						}) {
							if updatedResult[id: existingTrip.id]?
								.groups[id: groupName] == nil
							{
								updatedResult[id: existingTrip.id]?
									.groups[
										id: groupName] =
									.init(
										name: groupName,
										items: [])
							}

							updatedResult[id: existingTrip.id]?.groups[
								id: groupName]?.items.append(item)
							updatedResult[id: existingTrip.id]?.groups
								.sort { lhs, rhs in
									let sortOrder = store
										.locationsOrder

									if let lhsLocation =
										Location.Stripped(
											rawValue:
												lhs
												.name
										),
										let rhsLocation =
											Location
											.Stripped(
												rawValue:
													rhs
													.name
											),
										let lhsIndex =
											sortOrder
											.index(
												id:
													lhsLocation
													.id
											),
										let rhsIndex =
											sortOrder
											.index(
												id:
													rhsLocation
													.id
											)
									{
										return lhsIndex
											< rhsIndex
									} else {
										return lhs.name
											< rhs.name
									}
								}
						} else {
							updatedResult.append(
								ShoppingTrip(
									store: store,
									groups: .init(
										uniqueElements: [
											.init(
												name:
													groupName,
												items:
													.init(
														uniqueElements: [
															item
														]
													)
											)
										]
									)
								)
							)
						}

						return IdentifiedArray(
							uniqueElements:
								updatedResult
								.sorted { lhs, rhs in
									guard
										let lhsStore = lhs
											.store,
										let rhsStore = rhs
											.store
									else {
										if lhs.store == nil
											&& rhs.store
												== nil
										{
											return false
										} else if lhs.store
											== nil
										{
											return false
										} else {
											return true
										}
									}

									return lhsStore.name
										< rhsStore.name
								}
						)
					}
				)

				return .none
			case let .didTapShoppingTrip(trip):
				state.shoppingTripFeature = .init(trip: trip)

				return .none
			case .onAppear:
				return .run { send in
					let list = try await shoppingListClient.fetchShoppingList()
					let stores =
						try await groceryStoresClient.fetchGroceryStores()

					await send(.didReceiveShoppingList(list, stores))
				}
			case .shoppingTripFeature:
				return .none
			}
		}
		.ifLet(\.$shoppingTripFeature, action: \.shoppingTripFeature) {
			ShoppingTripFeature()
		}
	}
}
