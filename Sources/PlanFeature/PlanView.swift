import ComposableArchitecture
import ItemFormFeature
import Model
import SwiftUI

fileprivate struct ItemRow: View {
  let index: Int
  let item: ListItem
  let showList: Bool
  let didTapEditItem: (ListItem) -> Void

  var body: some View {
    HStack {
      VStack(alignment: .leading, spacing: 8) {
        Text(item.name)
          .font(.headline)
        Text("Quantity: \(item.quantity)")
          .font(.subheadline)
      }
      Spacer()
      Button {
        didTapEditItem(item)
      } label: {
        Text("Edit")
      }
    }
  }
}

public struct PlanView: View {
  var store: StoreOf<PlanFeature>

  public init(store: StoreOf<PlanFeature>) {
    self.store = store
  }

  public var body: some View {
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
              ItemRow(
                index: viewStore.groupedItems.index(id: groupedItem.id) ?? 0,
                item: item,
                showList: viewStore.showList,
                didTapEditItem: { item in viewStore.send(.didTapEditItem(item)) }
              )
              .offset(x: viewStore.showList ? 0 : 50)
              .opacity(viewStore.showList ? 1 : 0)
              .animation(
                .default
                  .delay(
                    Double(
                      groupedItem.items.index(id: item.id) ?? 0
                    ) * 0.1
                  ),
                value: viewStore.showList
              )
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
        initialState: .init(),
        reducer: {
          PlanFeature()
        }
      )
    )
  }
}
