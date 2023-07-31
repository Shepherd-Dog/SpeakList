import ComposableArchitecture

struct ItemFormFeature: Reducer {
  struct State: Equatable {
    var draftItem: ListItem
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
        state.draftItem.name = name
        return .none
      case let .didEditItemQuantity(quantity):
        return .none
      }
    }
  }
}
