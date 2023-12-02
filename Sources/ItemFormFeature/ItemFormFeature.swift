import ComposableArchitecture
import Model

@Reducer
public struct ItemFormFeature {
  @ObservableState
  public struct State: Equatable {
    public var item: ListItem
    public var stores: IdentifiedArrayOf<GroceryStore>

    public init(item: ListItem, stores: IdentifiedArrayOf<GroceryStore>) {
      self.item = item
      self.stores = stores
    }
  }

  public enum Action: Equatable {
    case didEditItemName(String)
    case didEditItemQuantity(Double)
    case didEditPreferredStore(GroceryStore?)
    case didEditPreferredStoreLocation(Location.Stripped)
    case didEditPreferredStoreLocationAisle(String)
  }

  public init() {}

  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case let .didEditItemName(name):
        state.item.name = name
        return .none
      case let .didEditItemQuantity(quantity):
        if quantity > 0 {
          state.item.quantity = Int(quantity)
        }
        return .none
      case let .didEditPreferredStore(store):
        state.item.preferredStoreLocation = GroceryStoreLocation(
          location: state.item.preferredStoreLocation.location,
          store: store
        )

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
