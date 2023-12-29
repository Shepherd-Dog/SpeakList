import ComposableArchitecture
import Model
import SwiftUI

public struct StoresView: View {
	@State var store: StoreOf<StoresFeature>

	public init(store: StoreOf<StoresFeature>) {
		self.store = store
	}

	public var body: some View {
		List {
			ForEach(self.store.stores) { store in
				HStack {
					Text(store.name)
					Spacer()
					Button {
						self.store.send(.editStoreButtonTapped(store))
					} label: {
						Text("Edit")
					}
				}
			}
		}
		.toolbar {
			ToolbarItem {
				Button {
					self.store.send(.addStoreButtonTapped)
				} label: {
					Text("Add")
				}
			}
		}
		.sheet(
			item: $store.scope(
				state: \.addStore,
				action: \.addStore
			)
		) { store in
			NavigationStack {
				StoreFormView(store: store)
					.toolbar {
						ToolbarItem {
							Button {
								self.store.send(
									.didCompleteAddStore)
							} label: {
								Text("Add")
							}
						}
						ToolbarItem(placement: .cancellationAction) {
							Button {
								self.store.send(.didCancelAddStore)
							} label: {
								Text("Cancel")
							}
						}
					}
					.navigationTitle("Add Store")
			}
		}
		.sheet(
			item: $store.scope(
				state: \.editStore,
				action: \.editStore
			)
		) { store in
			NavigationStack {
				StoreFormView(store: store)
					.toolbar {
						ToolbarItem {
							Button {
								self.store.send(
									.didCompleteEditStore)
							} label: {
								Text("Save")
							}
						}
						ToolbarItem(placement: .cancellationAction) {
							Button {
								self.store.send(.didCancelEditStore)
							} label: {
								Text("Cancel")
							}
						}
					}
					.navigationTitle("Edit Store")
			}
		}
		.onAppear {
			self.store.send(.onAppear)
		}
		.navigationTitle("Stores")
	}
}

#Preview {
	NavigationStack {
		StoresView(
			store: .init(
				initialState: .init(
					stores: IdentifiedArrayOf<GroceryStore>(
						uniqueElements: [
							//              GroceryStore(name: "Albertsons"),
							//              GroceryStore(name: "Kroger"),
							//              GroceryStore(name: "Natural Grocers"),
							//              GroceryStore(name: "Sprouts"),
						]
					)
				),
				reducer: { StoresFeature() }
			)
		)
	}
}
