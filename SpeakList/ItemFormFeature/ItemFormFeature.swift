import ComposableArchitecture

struct ItemFormFeature: Reducer {
  struct State: Equatable {
    var aisle: String = ""
    var item: ListItem
    var locationType: Location.Stripped = .unknown
    var stores: IdentifiedArrayOf<GroceryStore>
  }

  enum Action: Equatable {
    case didEditAisle(String)
    case didEditItemName(String)
    case didEditItemQuantity(String)
    case didEditPreferredStore(GroceryStore)
    case didEditPreferredStoreLocation(Location)
    case didEditPreferredStoreLocationAisle(String)
    case didEditLocationType(Location.Stripped)
    case location(Location)
    case onAppear
  }

  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case let .didEditAisle(aisle):
        state.aisle = aisle
        state.item.preferredStoreLocation.location = .aisle(aisle)
        return .none
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
      case let .didEditLocationType(type):
        state.locationType = type
//        state.item.preferredStoreLocation.location = location
        state.item.preferredStoreLocation.location = Location(stripped: type)

//        if type == "Aisle" {
//          state.item.preferredStoreLocation.location = .aisle("")
//        } else if type == "Dairy" {
//          state.item.preferredStoreLocation.location = .dairy
//        } else if type == "Produce" {
//          state.item.preferredStoreLocation.location = .produce
//        } else {
//          state.item.preferredStoreLocation.location = .unknown
//        }

        return .none
      case let .didEditPreferredStore(store):
        state.item.preferredStoreLocation.store = store

        return .none
      case let .didEditPreferredStoreLocation(location):
        state.item.preferredStoreLocation.location = location

        return .none
      case let .didEditPreferredStoreLocationAisle(aisle):
        state.aisle = aisle
        state.item.preferredStoreLocation.location = .aisle(aisle)

        return .none
      case let .location(location):
        return .none
      case .onAppear:
        state.locationType = state.item.preferredStoreLocation.location.stripped

        return .none
      }
    }
  }
}
