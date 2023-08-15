import Foundation

struct GroceryStoreLocation: Codable, Equatable, Hashable, Identifiable {
  var id = UUID()
  var location: Location
  var store: GroceryStore?
}
