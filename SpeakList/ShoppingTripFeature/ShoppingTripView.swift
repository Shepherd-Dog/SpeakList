import ComposableArchitecture
import SwiftUI

struct ShoppingTripView: View {
  var store: StoreOf<ShoppingTripFeature>

  var body: some View {
    WithViewStore(store) { $0 } content: { viewStore in
      List {
        ForEach(viewStore.trip.groups) { group in
          Section(header: Text(group.id)) {
            ForEach(group.items) { item in
              HStack {
                VStack(alignment: .leading, spacing: 8) {
                  Text(item.name)
                    .font(.headline)
                  Text("Quantity: \(item.quantity)")
                    .font(.subheadline)
                }
                Spacer()
                Button {
                  viewStore.send(.didTapItem(item))
                } label: {
                  Image(
                    systemName: item.checked ? "checkmark.circle.fill" : "circle"
                  )
                }
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
      .navigationTitle(viewStore.trip.store?.name ?? "None")
    }
  }
}

#Preview {
  NavigationStack {
    ShoppingTripView(
      store: .init(
        initialState: ShoppingTripFeature.State(
          trip: .init(
            store: .init(name: "Sprouts"),
            groups: .init(
              uniqueElements: [
//                .init(name: "Bananas", checked: false)
              ]
            )
          )
        )
      ) {
        ShoppingTripFeature()
      }
    )
  }
}
