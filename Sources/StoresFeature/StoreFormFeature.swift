import ComposableArchitecture
import Foundation
import Model

public struct StoreFormFeature: Reducer {
  public struct State: Equatable {
    var groceryStore: GroceryStore
  }

  public enum Action: Equatable {
    case onMove(IndexSet, Int)
    case didEditStoreName(String)
  }

  public var body: some ReducerOf<Self> {
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
