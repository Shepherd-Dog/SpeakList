import Dependencies
import Foundation
import IdentifiedCollections

public struct GroceryStore: Codable, Equatable, Hashable, Identifiable {
  public var id = UUID()
  public var name: String

  public var locationsOrder: IdentifiedArrayOf<Location.Stripped> = .init(
    uniqueElements: [
      .aisle,
      .dairy,
      .produce,
      .unknown
    ]
  )

  public init(
    id: UUID = UUID(),
    name: String
  ) {
    self.id = id
    self.name = name
  }
}

//extension GroceryStore {
//  static let none: Self = .init(id: UUID(0), name: "")
//}
