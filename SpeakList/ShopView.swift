import ComposableArchitecture
import SwiftUI

struct ListItem: Equatable, Identifiable {
  var id: String {
    return name
  }

  var name: String
  // TODO: should `quantity` be specific to the trip as well?
  var quantity: Int = 0
  // TODO: `checked` needs to live somewhere else, it is
  // specific to a shopping trip
  var checked: Bool

  var preferredStore: StoreLocation?
  var otherStores: IdentifiedArrayOf<StoreLocation> = []
}

struct Store: Equatable {
  var name: String
}

enum Location: Equatable {
  case aisle(String)
  case dairy
  case produce
}

struct StoreLocation: Equatable, Identifiable {
  var id: String {
    store.name
  }
  var location: Location
  var store: Store
}

struct ShopView: View {
  var store: StoreOf<ShopFeature>

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
              viewStore.send(.didTapListItem(item))
            } label: {
              if item.checked {
                Image(systemName: "checkmark.circle.fill")
              } else {
                Image(systemName: "circle.fill")
              }
            }
          }
        }
      }
      .toolbar {
        ToolbarItem {
          Button {
            viewStore.send(.didTapReadButton)
          } label: {
            Text("Start")
          }
        }
      }
      .onAppear {
        viewStore.send(.onAppear)
      }
    }
    .navigationTitle("Shop")
  }
}

#Preview {
  NavigationStack {
    ShopView(
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
        reducer: { ShopFeature() }
      )
    )
  }
}
