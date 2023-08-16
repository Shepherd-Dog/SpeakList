import Foundation

public struct GroceryStoreLocation: Codable, Equatable, Hashable, Identifiable {
  public var id = UUID()
  public var location: Location
  public var store: GroceryStore?

  public init(id: UUID = UUID(), location: Location, store: GroceryStore? = nil) {
    self.id = id
    self.location = location
    self.store = store
  }
}
