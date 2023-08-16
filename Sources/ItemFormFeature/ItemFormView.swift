import ComposableArchitecture
import Model
import SwiftUI

public struct ItemFormView: View {
  var store: StoreOf<ItemFormFeature>

  public init(store: StoreOf<ItemFormFeature>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(
      store,
      observe: { $0 }
    ) { viewStore in
      Form {
        Section(header: Text("Item")) {
          VStack(alignment: .leading) {
            TextField(
              "Name",
              text: viewStore.binding(
                get: \.item.name,
                send: { .didEditItemName($0) }
              )
            )
          }
          VStack(alignment: .leading) {
            TextField(
              "Quantity",
              text: viewStore.binding(
                get: { "\($0.item.quantity)" },
                send: { .didEditItemQuantity($0) }
              )
            )
          }
        }
        Section(header: Text("Preferred Store")) {
          VStack(alignment: .leading) {
            Picker(
              "Store",
              selection: viewStore.binding(
                get: \.item.preferredStoreLocation.store,
                send: { .didEditPreferredStore($0) }
              )
            ) {
              Text("None")
                .tag(Optional<GroceryStore>.none)
              ForEach(viewStore.stores) { store in
                Text(store.name)
                  .tag(Optional<GroceryStore>.some(store))
              }
            }
            Picker (
              "Location",
              selection: viewStore.binding(
                get: \.item.preferredStoreLocation.location.stripped,
                send: ItemFormFeature.Action.didEditPreferredStoreLocation
              )
            ) {
              ForEach(Location.Stripped.allCases) { locationType in
                Text("\(locationType.name)")
                  .tag(locationType)
              }
            }
            switch viewStore.item.preferredStoreLocation.location {
            case .aisle:
              HStack {
                Text("Aisle Number")
                Spacer()
                TextField(
                  "",
                  text: viewStore.binding(
                    get: {
                      if case let .aisle(aisle) = $0.item.preferredStoreLocation.location {
                        return aisle
                      } else {
                        return ""
                      }
                    },
                    send: ItemFormFeature.Action.didEditPreferredStoreLocationAisle
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
