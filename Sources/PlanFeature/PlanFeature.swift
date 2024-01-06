import ComposableArchitecture
import Foundation
import GroceryStoresClient
import ItemFormFeature
import Model
import ShoppingListClient

@Reducer
public struct PlanFeature {
	@ObservableState
	public struct State: Equatable {
		@Presents public var addItem: ItemFormFeature.State?
		@Presents public var editItem: ItemFormFeature.State?
		public var items: IdentifiedArrayOf<ListItem> = []
		public var showList = false
		public var stores: IdentifiedArrayOf<GroceryStore> = []

		public init(
			items: IdentifiedArrayOf<ListItem> = [],
			stores: IdentifiedArrayOf<GroceryStore> = [],
			showList: Bool = false
		) {
			self.addItem = addItem
			self.editItem = editItem
			self.items = items
			self.stores = stores
			self.showList = showList
		}

		public var groupedItems: IdentifiedArrayOf<GroupedListItem> {
			items.reduce([]) { partialResult, item in
				var updatedResult = partialResult
				let name = item.preferredStoreLocation.store?.name ?? "None"

				if partialResult.contains(where: { $0.name == name }) == false {
					updatedResult.append(
						.init(
							name: name,
							items: .init(uniqueElements: [item])))
				}

				updatedResult[id: name]?.items.append(item)

				return IdentifiedArray(
					uniqueElements:
						updatedResult
						.sorted { lhs, rhs in
							if lhs.name == "None" && rhs.name == "None"
							{
								return false
							}

							if lhs.name == "None" {
								return false
							}

							if rhs.name == "None" {
								return true
							}

							return lhs.name < rhs.name
						}
				)
			}
		}
	}

	public enum Action: Equatable {
		case addItem(PresentationAction<ItemFormFeature.Action>)
		case didCancelAddItem
		case didCancelEditItem
		case didCompleteAddItem
		case didCompleteEditItem
		case didReceiveGroceryStores(IdentifiedArrayOf<GroceryStore>)
		case didReceiveShoppingList(IdentifiedArrayOf<ListItem>)
		case didTapAddItem
		case didTapEditItem(ListItem)
		case editItem(PresentationAction<ItemFormFeature.Action>)
		case onAppear
		case onDelete(GroupedListItem.ID, IndexSet)
		case showList
	}

	@Dependency(\.groceryStoresClient) var groceryStoresClient
	@Dependency(\.shoppingListClient) var shoppingListClient

	public init() {}

	public var body: some ReducerOf<Self> {
		Reduce { state, action in
			switch action {
			case .addItem:
				return .none
			case .didCancelAddItem:
				state.addItem = nil
				return .none
			case .didCancelEditItem:
				state.editItem = nil
				return .none
			case .didCompleteAddItem:
				guard let addItem = state.addItem else {
					return .none
				}
				state.items.append(addItem.item)
				state.addItem = nil

				return .run { [items = state.items] _ in
					try await shoppingListClient.save(shoppingList: items)
				}
			case .didCompleteEditItem:
				guard let editItem = state.editItem else {
					return .none
				}
				state.items[id: editItem.item.id] = editItem.item
				state.editItem = nil

				return .run { [items = state.items] _ in
					try await shoppingListClient.save(shoppingList: items)
				}
			case let .didReceiveGroceryStores(stores):
				state.stores = stores

				return .none
			case let .didReceiveShoppingList(items):
				state.items = items

				return .none
			case .didTapAddItem:
				state.addItem = ItemFormFeature.State(
					item: .init(name: "", checked: false),
					stores: state.stores
				)

				return .none
			case let .didTapEditItem(item):
				state.editItem = ItemFormFeature.State(
					item: item,
					stores: state.stores
				)

				return .none
			case .editItem:
				return .none
			case .onAppear:
				return .run { send in
					let stores =
						try await groceryStoresClient.fetchGroceryStores()

					await send(.didReceiveGroceryStores(stores))

					let list = try await shoppingListClient.fetchShoppingList()

					await send(.didReceiveShoppingList(list))

					await send(.showList)
				}
			case let .onDelete(groupID, offsets):
				var ids: [ListItem.ID] = []

				for offset in offsets {
					if let group = state.groupedItems[id: groupID] {
						ids.append(group.items[offset].id)
					}
				}

				for id in ids {
					state.items.remove(id: id)
				}

				return .run { [items = state.items] _ in
					try await shoppingListClient.save(shoppingList: items)
				}
			case .showList:
				state.showList = true

				return .none
			}
		}
		.ifLet(\.$addItem, action: \.addItem) {
			ItemFormFeature()
		}
		.ifLet(\.$editItem, action: \.editItem) {
			ItemFormFeature()
		}
	}
}
