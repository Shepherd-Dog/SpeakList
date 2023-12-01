import ComposableArchitecture
import Foundation
import Model

@Reducer
public struct StoreFormFeature {
  public struct State: Equatable {
    public var groceryStore: GroceryStore

    public init(groceryStore: GroceryStore) {
      self.groceryStore = groceryStore
    }
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
