import ComposableArchitecture
import SwiftUI

struct StoresView: View {
  var store: StoreOf<StoresFeature>

  var body: some View {
    WithViewStore(
      store,
      observe: { state in
        state
      }
    ) { viewStore in
      List {
        ForEach(viewStore.stores) { store in
          HStack {
            Text(store.name)
          }
        }
      }
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
              GroceryStore(name: "Albertsons"),
              GroceryStore(name: "Kroger"),
              GroceryStore(name: "Natural Grocers"),
              GroceryStore(name: "Sprouts"),
            ]
          )
        ),
        reducer: { StoresFeature() }
      )
    )
  }
}
