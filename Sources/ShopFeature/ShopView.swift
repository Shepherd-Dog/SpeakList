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
    WithViewStore(
      store,
      observe: { state in
        state
      }
    ) { viewStore in
      List {
        ForEach(viewStore.trips) { trip in
          HStack {
            VStack(alignment: .leading, spacing: 8) {
              Text(trip.store?.name ?? "None")
                .font(.headline)
              Text("Number of items: \(trip.allItems.count)")
                .font(.subheadline)
            }
            Spacer()
            Button {
              viewStore.send(.didTapShoppingTrip(trip))
            } label: {
              Image(systemName: "chevron.forward")
            }
          }
        }
      }
      .onAppear {
        viewStore.send(.onAppear)
      }
      .navigationDestination(
        store: store.scope(
          state: \.$shoppingTripFeature,
          action: ShopFeature.Action.shoppingTripFeature
        )
      ) { store in
        ShoppingTripView(store: store)
      }
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
