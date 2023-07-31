import ComposableArchitecture
import SwiftUI

struct ListView: View {
  var store: StoreOf<ListFeature>

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
            }
            .navigationTitle("Add Item")
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
    ListView(
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
        reducer: { ListFeature() }
      )
    )
  }
}
