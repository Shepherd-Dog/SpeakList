import ComposableArchitecture
import SwiftUI

public struct ShoppingTripView: View {
	var store: StoreOf<ShoppingTripFeature>

	public init(store: StoreOf<ShoppingTripFeature>) {
		self.store = store
	}

	public var body: some View {
		List {
			ForEach(self.store.trip.groups) { group in
				Section(header: Text(group.id)) {
					ForEach(group.items) { item in
						HStack {
							VStack(alignment: .leading, spacing: 8) {
								Text(item.name)
									.font(.headline)
								Text("Quantity: \(item.quantity)")
									.font(.subheadline)
							}
							Spacer()
							Button {
								self.store.send(.didTapItem(item))
							} label: {
								Image(
									systemName: item.checked
										? "checkmark.circle.fill"
										: "circle"
								)
							}
						}
					}
				}
			}
		}
		.toolbar {
			ToolbarItem {
				Button {
					self.store.send(.didTapReadButton)
				} label: {
					Text("Start")
				}
			}
		}
		.onAppear {
			self.store.send(.onAppear)
		}
		.navigationTitle(self.store.trip.store?.name ?? "None")
	}
}

#Preview {
	NavigationStack {
		ShoppingTripView(
			store: .init(
				initialState: ShoppingTripFeature.State(
					trip: .init(
						store: .init(name: "Sprouts"),
						groups: .init(
							uniqueElements: [
								//                .init(name: "Bananas", checked: false)
							]
						)
					)
				)
			) {
				ShoppingTripFeature()
			}
		)
	}
}
