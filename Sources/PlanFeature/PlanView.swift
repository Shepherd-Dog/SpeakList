import ComposableArchitecture
import ItemFormFeature
import Model
import SwiftUI

private struct ItemRow: View {
	let index: Int
	let item: ListItem
	let showList: Bool
	let didTapEditItem: (ListItem) -> Void

	var body: some View {
		HStack {
			VStack(alignment: .leading, spacing: 8) {
				Text(item.name)
					.font(.headline)
				Text("Quantity: \(item.quantity)")
					.font(.subheadline)
			}
			Spacer()
			Button {
				didTapEditItem(item)
			} label: {
				Text("Edit")
			}
		}
	}
}

public struct PlanView: View {
	@State var store: StoreOf<PlanFeature>

	public init(store: StoreOf<PlanFeature>) {
		self.store = store
	}

	public var body: some View {
		List {
			ForEach(store.groupedItems) { groupedItem in
				Section(groupedItem.name) {
					ForEach(groupedItem.items) { item in
						ItemRow(
							index: store.groupedItems.index(
								id: groupedItem.id) ?? 0,
							item: item,
							showList: store.showList,
							didTapEditItem: { item in
								store.send(.didTapEditItem(item))
							}
						)
						.offset(x: store.showList ? 0 : 50)
						.opacity(store.showList ? 1 : 0)
						.animation(
							.default
								.delay(
									Double(
										groupedItem.items
											.index(
												id:
													item
													.id
											) ?? 0
									) * 0.1
								),
							value: store.showList
						)
					}
					.onDelete {
						store.send(.onDelete($0))
					}
				}
			}
		}
		.sheet(
			item: $store.scope(
				state: \.addItem,
				action: \.addItem
			)
		) { store in
			NavigationStack {
				ItemFormView(store: store)
					.toolbar {
						ToolbarItem {
							Button {
								self.store.send(.didCompleteAddItem)
							} label: {
								Text("Add")
							}
						}
						ToolbarItem(placement: .cancellationAction) {
							Button {
								self.store.send(.didCancelAddItem)
							} label: {
								Text("Cancel")
							}
						}
					}
					.navigationTitle("Add Item")
			}
		}
		.sheet(
			item: $store.scope(
				state: \.editItem,
				action: \.editItem
			)
		) { store in
			NavigationStack {
				ItemFormView(store: store)
					.toolbar {
						ToolbarItem {
							Button {
								self.store.send(
									.didCompleteEditItem)
							} label: {
								Text("Save")
							}
						}
						ToolbarItem(placement: .cancellationAction) {
							Button {
								self.store.send(.didCancelEditItem)
							} label: {
								Text("Cancel")
							}
						}
					}
					.navigationTitle("Edit Item")
			}
		}
		.toolbar {
			ToolbarItem {
				Button {
					store.send(.didTapAddItem)
				} label: {
					Text("Add")
				}
			}
		}
		.onAppear {
			store.send(.onAppear)
		}
		.navigationTitle("Plan")
	}
}

#Preview {
	NavigationStack {
		PlanView(
			store: .init(
				initialState: .init(),
				reducer: {
					PlanFeature()
				}
			)
		)
	}
}
