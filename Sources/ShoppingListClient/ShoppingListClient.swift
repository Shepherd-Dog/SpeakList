import Dependencies
import Foundation
import IdentifiedCollections
import Model

public struct ShoppingListClient {
  public var fetchShoppingList: () async throws -> IdentifiedArrayOf<ListItem>
  public var saveShoppingList: (IdentifiedArrayOf<ListItem>) async throws -> Void
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
  public static var liveValue: ShoppingListClient = .userDefaults
  public static var previewValue: ShoppingListClient = .userDefaults
}

extension DependencyValues {
  public var shoppingListClient: ShoppingListClient {
    get {
      self[ShoppingListClient.self]
    }
    set {
      self[ShoppingListClient.self] = newValue
    }
  }
}

extension ShoppingListClient {
  public static var mock = Self {
    [
      ListItem(id: UUID(711), name: "Apples", checked: false),
      ListItem(id: UUID(712), name: "Bananas", checked: false),
      ListItem(id: UUID(713), name: "Peanut Butter", checked: false),
      ListItem(id: UUID(714), name: "Protein Powder", checked: false),
    ]
  } saveShoppingList: { _ in
    // no-op
  }

}
