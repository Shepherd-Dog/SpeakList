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
        ForEach(viewStore.items) { item in
          HStack {
            Text(item.name)
            Spacer()
            Button {
              viewStore.send(.didTapEditItem(item))
            } label: {
              Text("Edit")
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
    }
    .navigationTitle("List")
  }
}

#Preview {
  NavigationStack {
    PlanView(
      store: .init(
        initialState: .init(
          items: IdentifiedArrayOf<ListItem>(
            uniqueElements: [
              ListItem(name: "Bananas", checked: false),
              ListItem(name: "Apples", checked: false),
              ListItem(name: "Protein Powder", checked: false),
              ListItem(name: "Peanut Butter", checked: false),
            ]
          )
        ),
        reducer: { PlanFeature() }
      )
    )
  }
}
