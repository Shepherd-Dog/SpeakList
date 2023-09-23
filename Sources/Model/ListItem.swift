import IdentifiedCollections
import Foundation

public struct ListItem: Codable, Equatable, Identifiable {
  public var id: UUID = UUID()

  public var name: String
  // TODO: should `quantity` be specific to the trip as well?
  public var quantity: Int = 1
  // TODO: `checked` needs to live somewhere else, it is
  // specific to a shopping trip
  public var checked: Bool
  public var preferredStoreLocation: GroceryStoreLocation = .unknown
  public var otherStoreLocations: IdentifiedArrayOf<GroceryStoreLocation> = []

//  var preferredStore: GroceryStore?
//  var otherStores: IdentifiedArrayOf<GroceryStore> = []

  public init(
    id: UUID = UUID(),
    name: String,
    quantity: Int = 1,
    checked: Bool,
    preferredStoreLocation: GroceryStoreLocation = .unknown,
    otherStoreLocations: IdentifiedArrayOf<GroceryStoreLocation> = []
  ) {
    self.id = id
    self.name = name
    self.quantity = quantity
    self.checked = checked
    self.preferredStoreLocation = preferredStoreLocation
    self.otherStoreLocations = otherStoreLocations
  }
}

extension ListItem {
  public static var mocks: IdentifiedArrayOf<ListItem> {
    IdentifiedArrayOf<ListItem>(
      uniqueElements: [
        ListItem(
          name: "Bananas",
          quantity: 7,
          checked: false
        ),
        ListItem(
          name: "Apples",
          quantity: 7,
          checked: false
        ),
        ListItem(
          name: "Protein Powder",
          quantity: 1,
          checked: false
        ),
        ListItem(
          name: "Peanut Butter",
          quantity: 1,
          checked: false
        ),
      ]
    )
  }
}
