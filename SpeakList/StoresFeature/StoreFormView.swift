import ComposableArchitecture
import SwiftUI

struct StoreFormView: View {
  var store: StoreOf<StoreFormFeature>

  var body: some View {
    WithViewStore(
      store,
      observe: { $0 }
    ) { viewStore in
      Form {
        Section(header: Text("Store")) {
          VStack(alignment: .leading) {
            Text("Name")
            TextField(
              "Item",
              text: viewStore.binding(
                get: \.groceryStore.name,
                send: { .didEditStoreName($0) }
              )
            )
            .padding()
            .border(.black)
          }
        }
      }
    }
  }
}

#Preview {
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
