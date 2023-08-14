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
              ForEach(Location.Stripped.allCases) { locationType in
                Text("\(locationType.name)")
                  .tag(locationType)
              }
            }
//            Picker (
//              "Location",
//              selection: viewStore.binding(
//                get: \.item.preferredStoreLocation.location,
//                send: ItemFormFeature.Action.didEditPreferredStoreLocation
//              )
//            ) {
//              ForEach(Location.allCases) { location in
//                Text("\(location.typeName)")
//                  .tag(location)
//              }
//            }
            switch viewStore.item.preferredStoreLocation.location {
            case .aisle:
              HStack {
                Text("Aisle Number")
                Spacer()
                TextField(
                  "",
                  text: viewStore.binding(
                    get: \.aisle,
                    send: ItemFormFeature.Action.didEditAisle
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
//            SwitchStore(
//              store.scope(
//                state: \.item.preferredStoreLocation.location,
//                action: ItemFormFeature.Action.location
//              )
//            ) { initialState in
//
//              CaseLet(
//                /Location.aisle,
//                 action: ItemFormFeature.Action.location
//              ) { caseLetStore in
//                WithViewStore(caseLetStore) { caseLetViewStore in
//                  HStack {
//                    Text("Aisle Number")
//                    Spacer()
//                    TextField(
//                      "",
//                      text: caseLetViewStore.binding(
//                        get: $0,
//                        send: ItemFormFeature.Action.didEditAisle
//                      )
//                    ).multilineTextAlignment(.trailing)
//                  }
//                }
//              }
//            }
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
