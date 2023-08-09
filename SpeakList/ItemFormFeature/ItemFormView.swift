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
        Section(header: Text("Store")) {
          VStack(alignment: .leading) {
            Picker(
              "Preferred",
              selection: viewStore.binding(
                get: {
                  $0.item.preferredStore ?? .none
                },
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
          }
        }
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
