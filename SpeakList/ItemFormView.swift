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
                get: \.draftItem.name,
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
                get: { "\($0.draftItem.quantity)" },
                send: { .didEditItemQuantity($0) }
              )
            )
            .padding()
            .border(.black)
          }
        }
        Section(header: Text("Store")) {
          VStack(alignment: .leading) {
            Text("Preferred")
            TextField(
              "Item",
              text: viewStore.binding(
                get: { "\($0.draftItem.quantity)" },
                send: { .didEditItemQuantity($0) }
              )
            )
            .padding()
            .border(.black)
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
        draftItem: .init(
          name: "Bananas",
          checked: false
        ),
        item: .init(
          name: "Bananas",
          checked: false
        )
      ),
      reducer: {
        ItemFormFeature()
      }
    )
  )
}
