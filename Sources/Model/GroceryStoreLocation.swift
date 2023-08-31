import Dependencies
import Foundation

public struct GroceryStoreLocation: Codable, Equatable, Hashable, Identifiable {
  public var id = UUID()
  public var location: Location
  public var store: GroceryStore?

  public init(id: UUID? = nil, location: Location, store: GroceryStore? = nil) {
    @Dependency(\.uuid) var uuid

    self.id = id ?? uuid()
    self.location = location
    self.store = store
  }

  public static let unknown: Self = .init(
    location: .unknown
  )
}
