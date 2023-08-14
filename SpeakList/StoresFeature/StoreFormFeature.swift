import ComposableArchitecture
import Foundation

struct StoreFormFeature: Reducer {
  struct State: Equatable {
    var groceryStore: GroceryStore
  }

  enum Action: Equatable {
    case onMove(IndexSet, Int)
    case didEditStoreName(String)
  }

  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case let .didEditStoreName(name):
        state.groceryStore.name = name

        return .none
      case let .onMove(indexSet, index):
        state.groceryStore.locationsOrder.move(fromOffsets: indexSet, toOffset: index)
        return .none
      }
    }
  }
}
