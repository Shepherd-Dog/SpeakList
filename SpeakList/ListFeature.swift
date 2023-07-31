import ComposableArchitecture

struct ListFeature: Reducer {
  struct State: Equatable {
    @PresentationState var addItem: ItemFormFeature.State?
    var items: IdentifiedArrayOf<ListItem> = []
  }

  enum Action: Equatable {
    case addItem(PresentationAction<ItemFormFeature.Action>)
    case didCompleteAddItem
    case didTapAddItem
  }

  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .addItem:
        return .none
      case .didCompleteAddItem:
        guard let addItem = state.addItem else {
          return .none
        }
        state.items.append(addItem.draftItem)
        state.addItem = nil

        return .none
      case .didTapAddItem:
        state.addItem = ItemFormFeature.State(
          draftItem: .init(name: "", checked: false),
          item: .init(name: "", checked: false)
        )

        return .none
      }
    }
    .ifLet(\.$addItem, action: /Action.addItem) {
      ItemFormFeature()
    }
  }
}
