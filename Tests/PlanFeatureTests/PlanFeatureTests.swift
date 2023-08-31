import ComposableArchitecture
import ItemFormFeature
import Model
import PlanFeature
import XCTest

@MainActor
class PlanFeatureTests: XCTestCase {
  func testBasics() async {
    let store = TestStore(
      initialState: PlanFeature.State()
    ) {
      PlanFeature()
    } withDependencies: {
      $0.groceryStoresClient = .mock
      $0.shoppingListClient = .mock
      $0.uuid = .incrementing
    }

    await store.send(.onAppear)

    await store.receive(
      .didReceiveGroceryStores(
        [
          GroceryStore(id: UUID(42), name: "Sprout"),
          GroceryStore(id: UUID(43), name: "Natural Grocers"),
          GroceryStore(id: UUID(44), name: "Kroger"),
        ]
      )
    ) {
      $0.stores = [
        GroceryStore(id: UUID(42), name: "Sprout"),
        GroceryStore(id: UUID(43), name: "Natural Grocers"),
        GroceryStore(id: UUID(44), name: "Kroger"),
      ]
    }
    await store.receive(
      .didReceiveShoppingList(
        [
          ListItem(id: UUID(711), name: "Apples", checked: false),
          ListItem(id: UUID(712), name: "Bananas", checked: false),
          ListItem(id: UUID(713), name: "Peanut Butter", checked: false),
          ListItem(id: UUID(714), name: "Protein Powder", checked: false),
        ]
      )
    ) {
      $0.items = [
        ListItem(id: UUID(711), name: "Apples", checked: false),
        ListItem(id: UUID(712), name: "Bananas", checked: false),
        ListItem(id: UUID(713), name: "Peanut Butter", checked: false),
        ListItem(id: UUID(714), name: "Protein Powder", checked: false),
      ]
    }

    XCTAssertNoDifference(
      [
        GroupedListItem(
          name: "None",
          items: [
            ListItem(id: UUID(711), name: "Apples", checked: false),
            ListItem(id: UUID(712), name: "Bananas", checked: false),
            ListItem(id: UUID(713), name: "Peanut Butter", checked: false),
            ListItem(id: UUID(714), name: "Protein Powder", checked: false),
          ]
        )
      ],
      store.state.groupedItems
    )

    await store.send(
      .didTapEditItem(
        ListItem(
          id: UUID(711),
          name: "Apples",
          checked: false
        )
      )
    ) {
      $0.editItem = ItemFormFeature.State(
        item: ListItem(
          id: UUID(711),
          name: "Apples",
          checked: false
        ),
        stores: [
          GroceryStore(id: UUID(42), name: "Sprout"),
          GroceryStore(id: UUID(43), name: "Natural Grocers"),
          GroceryStore(id: UUID(44), name: "Kroger"),
        ]
      )
    }

    await store.send(.editItem(.presented(.didEditItemName("Organic Apples")))) {
      $0.editItem?.item.name = "Organic Apples"
    }

    await store.send(
      .editItem(
        .presented(
          .didEditPreferredStore(
            GroceryStore(id: UUID(42), name: "Sprout")
          )
        )
      )
    ) {
      $0.editItem?.item.preferredStoreLocation = GroceryStoreLocation(
        id: UUID(1),
        location: .unknown,
        store: GroceryStore(id: UUID(42), name: "Sprout")
      ) 
    }

    await store.send(
      .editItem(
        .presented(
          .didEditPreferredStoreLocation(.produce)
        )
      )
    ) {
      $0.editItem?.item.preferredStoreLocation.location = .produce
    }

    await store.send(.didCompleteEditItem) {
      $0.editItem = nil
      $0.items[id: UUID(711)] = ListItem(
        id: UUID(711),
        name: "Organic Apples",
        checked: false,
        preferredStoreLocation: GroceryStoreLocation(
          id: UUID(1),
          location: .produce,
          store: GroceryStore(id: UUID(42), name: "Sprout")
        )
      )
    }

    XCTAssertNoDifference(
      [
        GroupedListItem(
          name: "Sprout",
          items: [
            ListItem(
              id: UUID(711),
              name: "Organic Apples",
              checked: false,
              preferredStoreLocation: GroceryStoreLocation(
                id: UUID(1),
                location: .produce,
                store: GroceryStore(id: UUID(42), name: "Sprout")
              )
            ),
          ]
        ),
        GroupedListItem(
          name: "None",
          items: [
            ListItem(id: UUID(712), name: "Bananas", checked: false),
            ListItem(id: UUID(713), name: "Peanut Butter", checked: false),
            ListItem(id: UUID(714), name: "Protein Powder", checked: false),
          ]
        )
      ],
      store.state.groupedItems
    )
  }
}
