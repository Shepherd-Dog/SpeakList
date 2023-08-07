import ComposableArchitecture
import Foundation

struct ListItem: Equatable, Identifiable {
  var id: UUID = UUID()

  var name: String
  // TODO: should `quantity` be specific to the trip as well?
  var quantity: Int = 0
  // TODO: `checked` needs to live somewhere else, it is
  // specific to a shopping trip
  var checked: Bool
//  var storeLocation: GroceryStoreLocation

  var preferredStore: GroceryStore?
  var otherStores: IdentifiedArrayOf<GroceryStore> = []
}
