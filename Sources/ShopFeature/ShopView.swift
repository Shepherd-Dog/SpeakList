import ComposableArchitecture
import Model
import ShoppingTripFeature
import SwiftUI

public struct ShopView: View {
	var store: StoreOf<ShopFeature>

	public init(store: StoreOf<ShopFeature>) {
		self.store = store
	}

	public var body: some View {
		List {
			ForEach(self.store.trips) { trip in
				HStack {
					VStack(alignment: .leading, spacing: 8) {
						Text(trip.store?.name ?? "None")
							.font(.headline)
						Text("Number of items: \(trip.allItems.count)")
							.font(.subheadline)
					}
					Spacer()
					Button {
						self.store.send(.didTapShoppingTrip(trip))
					} label: {
						Image(systemName: "chevron.forward")
					}
				}
			}
		}
		.onAppear {
			self.store.send(.onAppear)
		}
		.navigationDestination(
			store: store.scope(
				state: \.$shoppingTripFeature,
				action: \.shoppingTripFeature
			)
		) { store in
			ShoppingTripView(store: store)
		}
		.navigationTitle("Shop")
	}
}

#Preview {
	NavigationStack {
		ShopView(
			store: .init(
				initialState: .init(),
				reducer: { ShopFeature() }
			)
		)
	}
}
