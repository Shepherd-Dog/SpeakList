import ComposableArchitecture
import Foundation

struct GroceryStore: Codable, Equatable, Hashable, Identifiable {
  var id = UUID()
  var name: String

  var locationsOrder: IdentifiedArrayOf<Location.Stripped> = .init(
    uniqueElements: [
      .aisle,
      .dairy,
      .produce,
      .unknown
    ]
  )
}

extension GroceryStore {
  static let none: Self = .init(id: UUID(0), name: "")
}
