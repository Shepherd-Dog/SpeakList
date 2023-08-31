import ComposableArchitecture
import Model
import ShopFeature
import XCTest

@MainActor
class ShopFeatureTests: XCTestCase {
  func testBasics() async {
    let store = TestStore(
      initialState: ShopFeature.State()
    ) {
      ShopFeature()
    } withDependencies: {
      $0.uuid = .incrementing
    }

    let sprouts = GroceryStore(id: UUID(42), name: "Sprouts")

    var shoppingList: IdentifiedArrayOf<ListItem> = []

    withDependencies {
      $0.uuid = .incrementing
    } operation: {
      shoppingList = [
        ListItem(
          id: UUID(0),
          name: "Apples",
          checked: false,
          preferredStoreLocation: GroceryStoreLocation(
            id: UUID(0),
            location: .produce,
            store: sprouts
          )
        ),
        ListItem(
          id: UUID(1),
          name: "Bananas",
          checked: false,
          preferredStoreLocation: GroceryStoreLocation(
            id: UUID(0),
            location: .produce,
            store: sprouts
          )
        ),
      ]
    }


    await store.send(
      .didReceiveShoppingList(shoppingList)
    ) {
      $0.trips = IdentifiedArrayOf<ShoppingTrip>(
        uniqueElements: [
          ShoppingTrip(
            id: UUID(0),
            store: sprouts,
            groups: IdentifiedArrayOf<GroupedListItem>(
              uniqueElements: [
                GroupedListItem(
                  name: "Produce",
                  items: IdentifiedArrayOf<ListItem>(
                    uniqueElements: [
                      ListItem(
                        id: UUID(0),
                        name: "Apples",
                        checked: false,
                        preferredStoreLocation: GroceryStoreLocation(
                          id: UUID(0),
                          location: .produce,
                          store: sprouts
                        )
                      ),
                      ListItem(
                        id: UUID(1),
                        name: "Bananas",
                        checked: false,
                        preferredStoreLocation: GroceryStoreLocation(
                          id: UUID(0),
                          location: .produce,
                          store: sprouts
                        )
                      ),
                    ]
                  )
                )
              ]
            )
          )
        ]
      )
      XCTAssertEqual($0.trips.first?.allItems.count, 2)
    }
  }
}
