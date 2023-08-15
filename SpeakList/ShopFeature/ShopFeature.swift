import ComposableArchitecture
import Foundation

struct ShoppingTrip: Equatable, Identifiable {
  var id = UUID()
  var store: GroceryStore?
  var groups: IdentifiedArrayOf<GroupedListItem>

  var allItems: IdentifiedArrayOf<ListItem> {
    return groups.reduce([]) { partialResult, groupedListItem in
      var updatedResult = partialResult

      updatedResult.append(contentsOf: groupedListItem.items)

      return updatedResult
    }
  }
}

struct ShopFeature: Reducer {
  struct State: Equatable {
    @PresentationState var shoppingTripFeature: ShoppingTripFeature.State?
    var trips: IdentifiedArrayOf<ShoppingTrip> = []
  }

  enum Action: Equatable {
    case didReceiveShoppingList(IdentifiedArrayOf<ListItem>)
    case didTapShoppingTrip(ShoppingTrip)
    case onAppear
    case shoppingTripFeature(PresentationAction<ShoppingTripFeature.Action>)
  }

  @Dependency(\.mainQueue) var mainQueue
  @Dependency(\.shoppingListClient) var shoppingListClient

  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case let .didReceiveShoppingList(items):
        state.trips = items.reduce([], { partialResult, item in
          var updatedResult = partialResult
          let store = item.preferredStoreLocation.store
          let groupName = item.preferredStoreLocation.location.name

          if partialResult.contains(where: { $0.store == store }) == false {
            updatedResult.append(
              .init(
                store: store,
                groups: .init(
                  uniqueElements: [
                    .init(
                      name: groupName,
                      items: .init(uniqueElements: [item])
                    )
                  ]
                )
              )
            )
          }

          updatedResult[id: store?.id ?? UUID(0)]?.groups[id: groupName]?.items.append(item)

          return IdentifiedArray(
            uniqueElements: updatedResult
              .sorted { lhs, rhs in
                guard let lhsStore = lhs.store,
                      let rhsStore = rhs.store else {
                  if lhs.store == nil && rhs.store == nil {
                    return false
                  } else if lhs.store == nil {
                    return false
                  } else {
                    return true
                  }
                }

                return lhsStore.name < rhsStore.name
              }
            )
        }
        )

        return .none
      case let .didTapShoppingTrip(trip):
        state.shoppingTripFeature = .init(trip: trip)

        return .none
      case .onAppear:
        return .run { send in
          let list = try await shoppingListClient.fetchShoppingList()

          await send(.didReceiveShoppingList(list))
        }
      case .shoppingTripFeature:
        return .none
      }
    }
    .ifLet(\.$shoppingTripFeature, action: /Action.shoppingTripFeature) {
      ShoppingTripFeature()
    }
  }
}
