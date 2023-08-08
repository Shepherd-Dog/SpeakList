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
            Spacer()
            Button {
              viewStore.send(.editStoreButtonTapped(store))
            } label: {
              Text("Edit")
            }
          }
        }
      }
      .toolbar {
        ToolbarItem {
          Button {
            viewStore.send(.addStoreButtonTapped)
          } label: {
            Text("Add")
          }
        }
      }
      .sheet(
        store: store.scope(
          state: \.$addStore,
          action: { .addStore($0) }
        )
      ) { store in
        NavigationStack {
          StoreFormView(store: store)
            .toolbar {
              ToolbarItem {
                Button {
                  viewStore.send(.didCompleteAddStore)
                } label: {
                  Text("Add")
                }
              }
              ToolbarItem(placement: .cancellationAction) {
                Button {
                  viewStore.send(.didCancelAddStore)
                } label: {
                  Text("Cancel")
                }
              }
            }
            .navigationTitle("Add Store")
        }
      }
      .sheet(
        store: store.scope(
          state: \.$editStore,
          action: { .editStore($0) }
        )
      ) { store in
        NavigationStack {
          StoreFormView(store: store)
            .toolbar {
              ToolbarItem {
                Button {
                  viewStore.send(.didCompleteEditStore)
                } label: {
                  Text("Save")
                }
              }
              ToolbarItem(placement: .cancellationAction) {
                Button {
                  viewStore.send(.didCancelEditStore)
                } label: {
                  Text("Cancel")
                }
              }
            }
            .navigationTitle("Edit Store")
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
