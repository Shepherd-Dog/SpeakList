import Foundation

struct GroceryStore: Codable, Equatable, Hashable, Identifiable {
  var id = UUID()
  var name: String
}
