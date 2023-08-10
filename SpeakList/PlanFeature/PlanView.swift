import ComposableArchitecture
import SwiftUI

struct PlanView: View {
  var store: StoreOf<PlanFeature>

  var body: some View {
    WithViewStore(
      store,
      observe: { state in
        state
      }
    ) { viewStore in
      List {
        ForEach(viewStore.groupedItems) { groupedItem in
          Section(groupedItem.name) {
            ForEach(groupedItem.items) { item in
              HStack {
                VStack(alignment: .leading, spacing: 8) {
                  Text(item.name)
                    .font(.headline)
                  Text("Quantity: \(item.quantity)")
                    .font(.subheadline)
                }
                Spacer()
                Button {
                  viewStore.send(.didTapEditItem(item))
                } label: {
                  Text("Edit")
                }
              }
            }
          }
        }
      }
      .sheet(
        store: store.scope(
          state: \.$addItem,
          action: { .addItem($0) }
        )
      ) { store in
        NavigationStack {
          ItemFormView(store: store)
            .toolbar {
              ToolbarItem {
                Button {
                  viewStore.send(.didCompleteAddItem)
                } label: {
                  Text("Add")
                }
              }
              ToolbarItem(placement: .cancellationAction) {
                Button {
                  viewStore.send(.didCancelAddItem)
                } label: {
                  Text("Cancel")
                }
              }
            }
            .navigationTitle("Add Item")
        }

      }
      .sheet(
        store: store.scope(
          state: \.$editItem,
          action: { .editItem($0) }
        )
      ) { store in
        NavigationStack {
          ItemFormView(store: store)
            .toolbar {
              ToolbarItem {
                Button {
                  viewStore.send(.didCompleteEditItem)
                } label: {
                  Text("Save")
                }
              }
              ToolbarItem(placement: .cancellationAction) {
                Button {
                  viewStore.send(.didCancelEditItem)
                } label: {
                  Text("Cancel")
                }
              }
            }
            .navigationTitle("Edit Item")
        }
      }
      .toolbar {
        ToolbarItem {
          Button {
            viewStore.send(.didTapAddItem)
          } label: {
            Text("Add")
          }
        }
      }
      .onAppear {
        viewStore.send(.onAppear)
      }
    }
    .navigationTitle("Plan")
  }
}

#Preview {
  NavigationStack {
    PlanView(
      store: .init(
        initialState: .init(
          items: IdentifiedArrayOf<ListItem>(
            uniqueElements: [
              ListItem(
                name: "Bananas",
                quantity: 7,
                checked: false
              ),
              ListItem(
                name: "Apples",
                quantity: 7,
                checked: false
              ),
              ListItem(
                name: "Protein Powder",
                quantity: 1,
                checked: false
              ),
              ListItem(
                name: "Peanut Butter",
                quantity: 1,
                checked: false
              ),
            ]
          ),
          stores: IdentifiedArrayOf<GroceryStore>(
            uniqueElements: [
//              GroceryStore(name: "Albertsons"),
//              GroceryStore(name: "Kroger"),
//              GroceryStore(name: "Natural Grocers"),
//              GroceryStore(name: "Zatural Grocers"),
            ]
          )
        ),
        reducer: { PlanFeature() }
      )
    )
  }
}
