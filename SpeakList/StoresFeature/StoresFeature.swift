import ComposableArchitecture

struct StoresFeature: Reducer {
  struct State: Equatable {
    var stores: IdentifiedArrayOf<GroceryStore> = []
    @PresentationState var addStore: StoreFormFeature.State?
    @PresentationState var editStore: StoreFormFeature.State?
  }

  enum Action: Equatable {
    case addStore(PresentationAction<StoreFormFeature.Action>)
    case addStoreButtonTapped
    case didCancelAddStore
    case didCancelEditStore
    case didCompleteAddStore
    case didCompleteEditStore
    case editStore(PresentationAction<StoreFormFeature.Action>)
    case editStoreButtonTapped(GroceryStore)
  }

  var body: some ReducerOf<Self> {
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
        return .none
      case .didCompleteEditStore:
        guard let editStore = state.editStore else {
          // TODO: Error? XCTFail?
          return .none
        }
        state.stores[id: editStore.groceryStore.id] = editStore.groceryStore
        state.editStore = nil
        return .none
      case .editStore:
        return .none
      case let .editStoreButtonTapped(store):
        state.editStore = .init(groceryStore: store)
        return .none
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
