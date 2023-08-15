import ComposableArchitecture

struct ItemFormFeature: Reducer {
  struct State: Equatable {
    var item: ListItem
    var stores: IdentifiedArrayOf<GroceryStore>
  }

  enum Action: Equatable {
    case didEditItemName(String)
    case didEditItemQuantity(String)
    case didEditPreferredStore(GroceryStore?)
    case didEditPreferredStoreLocation(Location.Stripped)
    case didEditPreferredStoreLocationAisle(String)
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
      case let .didEditPreferredStore(store):
        state.item.preferredStoreLocation.store = store

        return .none
      case let .didEditPreferredStoreLocation(location):
        state.item.preferredStoreLocation.location = Location(stripped: location)

        return .none
      case let .didEditPreferredStoreLocationAisle(aisle):
        state.item.preferredStoreLocation.location = .aisle(aisle)

        return .none
      }
    }
  }
}
