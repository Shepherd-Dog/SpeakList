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

  public var quantityAsDouble: Double {
    Double(quantity)
  }

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
  public static let mockApples: Self = ListItem(
    id: UUID(711),
    name: "Apples",
    quantity: 7,
    checked: false,
    preferredStoreLocation: GroceryStoreLocation(
      id: UUID(1),
      location: .produce,
      store: GroceryStore(
        id: UUID(42),
        name: "Sprouts"
      )
    )
  )

  public static let mockBananas: Self = ListItem(
    id: UUID(712),
    name: "Bananas",
    quantity: 7,
    checked: false,
    preferredStoreLocation: GroceryStoreLocation(
      id: UUID(0),
      location: .produce,
      store: GroceryStore(
        id: UUID(42),
        name: "Sprouts"
      )
    )
  )

  public static let mockPeanutButter: Self = ListItem(
    id: UUID(714),
    name: "Peanut Butter",
    quantity: 1,
    checked: false,
    preferredStoreLocation: GroceryStoreLocation(
      id: UUID(3),
      location: .aisle("42"),
      store: GroceryStore(
        id: UUID(44),
        name: "Kroger"
      )
    )
  )

  public static let mockProteinPowder: Self = ListItem(
    id: UUID(713),
    name: "Protein Powder",
    quantity: 1,
    checked: false,
    preferredStoreLocation: GroceryStoreLocation(
      id: UUID(2),
      location: .aisle("17"),
      store: GroceryStore(
        id: UUID(43),
        name: "Natural Grocers"
      )
    )
  )

  public static var mocks: IdentifiedArrayOf<ListItem> {
    IdentifiedArrayOf<ListItem>(
      uniqueElements: [
        .mockBananas,
        .mockApples,
        .mockProteinPowder,
        .mockPeanutButter,
      ]
    )
  }
}
