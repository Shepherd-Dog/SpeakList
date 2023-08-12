import ComposableArchitecture
import SwiftUI

struct ItemFormView: View {
  var store: StoreOf<ItemFormFeature>

  var body: some View {
    WithViewStore(
      store,
      observe: { $0 }
    ) { viewStore in
      Form {
        Section(header: Text("Item")) {
          VStack(alignment: .leading) {
            Text("Name")
            TextField(
              "Item",
              text: viewStore.binding(
                get: \.item.name,
                send: { .didEditItemName($0) }
              )
            )
            .padding()
            .border(.black)
          }
          VStack(alignment: .leading) {
            Text("Quantity")
            TextField(
              "Item",
              text: viewStore.binding(
                get: { "\($0.item.quantity)" },
                send: { .didEditItemQuantity($0) }
              )
            )
            .padding()
            .border(.black)
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
                .tag(GroceryStore.none)
              ForEach(viewStore.stores) { store in
                Text(store.name)
                  .tag(store)
              }
            }
            Picker (
              "Location",
              selection: viewStore.binding(
                get: \.locationType,
                send: ItemFormFeature.Action.didEditLocationType
              )
            ) {
              ForEach(0..<Location.types.count) { index in
                Text("\(Location.types[index])")
                  .tag(Location.types[index])
              }
            }
            switch viewStore.item.preferredStoreLocation.location {
            case .aisle:
              HStack {
                Text("Aisle Number")
                Spacer()
                TextField(
                  "Aisle Number",
                  text: viewStore.binding(
                    get: \.aisle,
                    send: ItemFormFeature.Action.didEditAisle
                  )
                )
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
      .onAppear {
        viewStore.send(.onAppear)
      }
    }
  }
}

extension GroceryStore {
  static let none: Self = .init(id: .zeros, name: "")
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

extension UUID {
  static let zeros = UUID(uuidString: "00000000-0000-0000-0000-000000000000")!
}
