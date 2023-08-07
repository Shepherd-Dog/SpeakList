import ComposableArchitecture

struct ItemFormFeature: Reducer {
  struct State: Equatable {
    var item: ListItem
  }

  enum Action: Equatable {
    case didEditItemName(String)
    case didEditItemQuantity(String)
  }

  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case let .didEditItemName(name):
        state.item.name = name
        return .none
      case let .didEditItemQuantity(quantity):
        guard let quantity = Int(quantity) else {
          // TODO: error
          return .none
        }

        state.item.quantity = quantity
        return .none
      }
    }
  }
}
