import ComposableArchitecture
import Foundation

struct ShoppingListClient {
  var fetchShoppingList: () async throws -> IdentifiedArrayOf<ListItem>
  var saveShoppingList: (IdentifiedArrayOf<ListItem>) async throws -> Void
}

extension ShoppingListClient {
  static let userDefaults: Self = .init {
    let json = UserDefaults.standard.string(forKey: "shopping-list")

    guard let data = json?.data(using: .utf8) else {
      return []
    }

    return try JSONDecoder().decode(IdentifiedArrayOf<ListItem>.self, from: data)
  } saveShoppingList: { stores in
    let json = String(data: try JSONEncoder().encode(stores), encoding: .utf8)

    UserDefaults.standard.setValue(json, forKey: "shopping-list")
  }
}

extension ShoppingListClient: DependencyKey {
  static var liveValue: ShoppingListClient = .userDefaults
  static var previewValue: ShoppingListClient = .userDefaults
}

extension DependencyValues {
  var shoppingListClient: ShoppingListClient {
    get {
      self[ShoppingListClient.self]
    }
    set {
      self[ShoppingListClient.self] = newValue
    }
  }
}
