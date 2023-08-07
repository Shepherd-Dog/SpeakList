import ComposableArchitecture

struct PlanFeature: Reducer {
  struct State: Equatable {
    @PresentationState var addItem: ItemFormFeature.State?
    @PresentationState var editItem: ItemFormFeature.State?
    var items: IdentifiedArrayOf<ListItem> = []
  }

  enum Action: Equatable {
    case addItem(PresentationAction<ItemFormFeature.Action>)
    case didCancelAddItem
    case didCancelEditItem
    case didCompleteAddItem
    case didCompleteEditItem
    case didTapAddItem
    case didTapEditItem(ListItem)
    case editItem(PresentationAction<ItemFormFeature.Action>)
  }

  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .addItem:
        return .none
      case .didCancelAddItem:
        state.addItem = nil
        return .none
      case .didCancelEditItem:
        state.editItem = nil
        return .none
      case .didCompleteAddItem:
        guard let addItem = state.addItem else {
          return .none
        }
        state.items.append(addItem.item)
        state.addItem = nil

        return .none
      case .didCompleteEditItem:
        guard let editItem = state.editItem else {
          return .none
        }
        state.items[id: editItem.item.id] = editItem.item
        state.editItem = nil

        return .none
      case .didTapAddItem:
        state.addItem = ItemFormFeature.State(
          item: .init(name: "", checked: false)
        )

        return .none
      case let .didTapEditItem(item):
        state.editItem = ItemFormFeature.State(
          item: item
        )

        return .none
      case .editItem:
        return .none
      }
    }
    .ifLet(\.$addItem, action: /Action.addItem) {
      ItemFormFeature()
    }
    .ifLet(\.$editItem, action: /Action.editItem) {
      ItemFormFeature()
    }
  }
}
