import ComposableArchitecture
import SwiftUI

struct ShopView: View {
  var store: StoreOf<ShopFeature>

  var body: some View {
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
              Text(trip.store.name)
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
        initialState: .init(
          trips: IdentifiedArrayOf<ShoppingTrip>(
            uniqueElements: [
//              ListItem(name: "Bananas", checked: false),
//              ListItem(name: "Apples", checked: false),
//              ListItem(name: "Protein Powder", checked: false),
//              ListItem(name: "Peanut Butter", checked: false),
            ]
          )
        ),
        reducer: { ShopFeature() }
      )
    )
  }
}
