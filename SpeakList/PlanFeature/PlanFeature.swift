import ComposableArchitecture

struct GroupedListItem: Identifiable {
  var id: String {
    name
  }
  var name: String
  var items: IdentifiedArrayOf<ListItem>
}

struct PlanFeature: Reducer {
  struct State: Equatable {
    @PresentationState var addItem: ItemFormFeature.State?
    @PresentationState var editItem: ItemFormFeature.State?
    var items: IdentifiedArrayOf<ListItem> = []
    var stores: IdentifiedArrayOf<GroceryStore> = []

    var groupedItems: IdentifiedArrayOf<GroupedListItem> {
      items.reduce([]) { partialResult, item in
        var updatedResult = partialResult
        let name = item.preferredStore?.name ?? "None"

        if partialResult.contains(where: { $0.name == name }) == false {
          updatedResult.append(.init(name: name, items: .init(uniqueElements: [item])))
        }

        updatedResult[id: name]?.items.append(item)

        return IdentifiedArray(
          uniqueElements: updatedResult
            .sorted { lhs, rhs in
              if lhs.name == "None" && rhs.name == "None" {
                return false
              }

              if lhs.name == "None" {
                return false
              }

              if rhs.name == "None" {
                return true
              }

              return lhs.name < rhs.name
            }
        )
      }
    }
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
          item: .init(name: "", checked: false),
          stores: state.stores
        )

        return .none
      case let .didTapEditItem(item):
        state.editItem = ItemFormFeature.State(
          item: item,
          stores: state.stores
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
