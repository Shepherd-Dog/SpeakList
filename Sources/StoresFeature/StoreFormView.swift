import ComposableArchitecture
import Model
import SwiftUI

struct StoreFormView: View {
  @State var store: StoreOf<StoreFormFeature>

  var body: some View {
    VStack {
      VStack {
        TextField(
          "Name",
          text: self.$store.groceryStore.name.sending(\.didEditStoreName)
        )
      }
      .padding(20)
      List {
        Section(
          header: Text("Layout"),
          footer: Text("The layout of the store determines the order for items to be sorted.")
            .font(.caption)
        ) {
          ForEach(self.store.groceryStore.locationsOrder) { location in
            Text(location.name)
          }
          .onMove { indexSet, index in
            self.store.send(.onMove(indexSet, index))
          }
        }
      }
      .environment(\.editMode, .constant(.active))
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
