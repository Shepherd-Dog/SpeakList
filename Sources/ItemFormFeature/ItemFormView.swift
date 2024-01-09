import ComposableArchitecture
import Model
import SwiftUI

public struct ItemFormView: View {
	@State var store: StoreOf<ItemFormFeature>

	public init(store: StoreOf<ItemFormFeature>) {
		self.store = store
	}

	public var body: some View {
		Form {
			Section(header: Text("Item")) {
				VStack(alignment: .leading) {
					TextField(
						"Name",
						text: self.$store.item.name.sending(
							\.didEditItemName)
					)
				}
				VStack(alignment: .leading) {
					HStack {
						Stepper(
							value: self.$store.item.quantityAsDouble
								.sending(\.didEditItemQuantity),
							in: 1...Double.greatestFiniteMagnitude,
							format: .number,
							label: {
								HStack {
									Text("Quantity")
									Spacer()
									Text(
										"\(self.store.item.quantity)"
									)
								}
							}
						)
					}
				}
			}
			Section(header: Text("Preferred Store")) {
				VStack(alignment: .leading) {
					Picker(
						"Store",
						selection: self.$store.item.preferredStoreLocation
							.storeID.sending(
								\.didEditPreferredStore)
					) {
						Text("None")
							.tag(Optional<GroceryStore.ID>.none)
						ForEach(self.store.stores) { groceryStore in
							Text(groceryStore.name)
								.tag(
									Optional<GroceryStore.ID>
										.some(
											groceryStore
												.id
										)
								)
						}
					}
					Picker(
						"Location",
						selection: self.$store.item.preferredStoreLocation
							.location.stripped.sending(
								\.didEditPreferredStoreLocation)
					) {
						ForEach(Location.Stripped.allCases) {
							locationType in
							Text("\(locationType.name)")
								.tag(locationType)
						}
					}
					switch self.store.item.preferredStoreLocation.location {
					case .aisle:
						HStack {
							Text("Aisle Number")
							Spacer()
							TextField(
								"",
								text: self.$store.item
									.preferredStoreLocation
									.location.aisleName.sending(
										\.didEditPreferredStoreLocationAisle
									)
							).multilineTextAlignment(.trailing)
						}
					case .dairy:
						EmptyView()
					case .produce:
						EmptyView()
					case .unknown:
						EmptyView()
					}
				}
			}
		}
	}
}

#Preview {
	ItemFormView(
		store: ComposableArchitecture.Store(
			initialState: ItemFormFeature.State(
				item: .init(
					name: "Bananas",
					checked: false
				),
				stores: [
					.init(name: "Albertsons"),
					.init(name: "Natural Grocers"),
				]
			),
			reducer: {
				ItemFormFeature()
			}
		)
	)
}
