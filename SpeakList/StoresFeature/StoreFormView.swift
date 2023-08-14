import ComposableArchitecture
import SwiftUI

struct StoreFormView: View {
  var store: StoreOf<StoreFormFeature>

  var body: some View {
    WithViewStore(
      store,
      observe: { $0 }
    ) { viewStore in
//      ScrollView {
        VStack {
          //        Form {
          
//          Section(header: Text("Store")) {
          VStack {
            TextField(
              "Name",
              text: viewStore.binding(
                get: \.groceryStore.name,
                send: { .didEditStoreName($0) }
              )
            )
          }
          .padding(20)
//          }
          //        }
          //        Section(header: Text("Layout")) {

          List {
            Section(
              header: Text("Layout"),
              footer: Text("The layout of the store determines the order for items to be sorted.")
                .font(.caption)
            ) {
              ForEach(viewStore.groceryStore.locationsOrder) { location in
                Text(location.name)
              }
              .onMove { indexSet, index in
                viewStore.send(.onMove(indexSet, index))
              }
            }
          }
          .environment(\.editMode, .constant(.active))

          //        }
        }
//      }
    }
    .background(Color(uiColor: .systemGroupedBackground))
  }
}

#Preview {
  NavigationStack {
    StoreFormView(
      store: Store(
        initialState: StoreFormFeature.State(
          groceryStore: .init(
            name: "Natural Grocers"
          )
        ),
        reducer: {
          StoreFormFeature()
        }
      )
    )
  }
}
