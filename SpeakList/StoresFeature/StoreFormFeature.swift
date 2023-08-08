import ComposableArchitecture

struct StoreFormFeature: Reducer {
  struct State: Equatable {
    var groceryStore: GroceryStore
  }

  enum Action: Equatable {
    case didEditStoreName(String)
  }

  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case let .didEditStoreName(name):
        state.groceryStore.name = name

        return .none
      }
    }
  }
}
