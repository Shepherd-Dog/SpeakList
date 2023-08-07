import ComposableArchitecture
import SwiftUI

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
