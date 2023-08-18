import ComposableArchitecture
import GroceryStoresClient
import Model

public struct StoresFeature: Reducer {
  public struct State: Equatable {
    public var stores: IdentifiedArrayOf<GroceryStore> = []
    @PresentationState public var addStore: StoreFormFeature.State?
    @PresentationState public var editStore: StoreFormFeature.State?

    public init(stores: IdentifiedArrayOf<GroceryStore> = []) {
      self.stores = stores
    }
  }

  public enum Action: Equatable {
    case addStore(PresentationAction<StoreFormFeature.Action>)
    case addStoreButtonTapped
    case didCancelAddStore
    case didCancelEditStore
    case didCompleteAddStore
    case didCompleteEditStore
    case editStore(PresentationAction<StoreFormFeature.Action>)
    case editStoreButtonTapped(GroceryStore)
    case didReceiveGroceryStores(IdentifiedArrayOf<GroceryStore>)
    case onAppear
  }

  @Dependency(\.groceryStoresClient) var groceryStoresClient

  public init() {}

  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .addStore:
        return .none
      case .addStoreButtonTapped:
        state.addStore = .init(groceryStore: .init(name: ""))
        return .none
      case .didCancelAddStore:
        state.addStore = nil
        return .none
      case .didCancelEditStore:
        state.editStore = nil
        return .none
      case .didCompleteAddStore:
        guard let addStore = state.addStore else {
          // TODO: Error? XCTFail?
          return .none
        }
        state.stores.append(addStore.groceryStore)
        state.addStore = nil

        return .run { [stores = state.stores] _ in
          try await groceryStoresClient.saveGroceryStores(stores)
        }
      case .didCompleteEditStore:
        guard let editStore = state.editStore else {
          // TODO: Error? XCTFail?
          return .none
        }
        state.stores[id: editStore.groceryStore.id] = editStore.groceryStore
        state.editStore = nil

        return .run { [stores = state.stores] _ in
          try await groceryStoresClient.saveGroceryStores(stores)
        }
      case let .didReceiveGroceryStores(stores):
        state.stores = stores
        return .none
      case .editStore:
        return .none
      case let .editStoreButtonTapped(store):
        state.editStore = .init(groceryStore: store)
        return .none
      case .onAppear:
        return .run { send in
          let stores = try await groceryStoresClient.fetchGroceryStores()

          await send(.didReceiveGroceryStores(stores))
        }
      }
    }
    .ifLet(
      \.$addStore,
      action: /Action.addStore
    ) {
      StoreFormFeature()
    }
    .ifLet(
      \.$editStore,
      action: /Action.editStore
    ) {
      StoreFormFeature()
    }
  }
}
