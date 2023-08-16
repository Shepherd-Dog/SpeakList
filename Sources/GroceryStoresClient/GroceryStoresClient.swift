import Dependencies
import IdentifiedCollections
import Foundation
import Model

public struct GroceryStoresClient {
  public var fetchGroceryStores: () async throws -> IdentifiedArrayOf<GroceryStore>
  public var saveGroceryStores: (IdentifiedArrayOf<GroceryStore>) async throws -> Void
}

extension GroceryStoresClient {
  static let userDefaults: Self = .init {
    let json = UserDefaults.standard.string(forKey: "grocery-stores")

    guard let data = json?.data(using: .utf8) else {
      return []
    }

    return try JSONDecoder().decode(IdentifiedArrayOf<GroceryStore>.self, from: data)
  } saveGroceryStores: { stores in
    let json = String(data: try JSONEncoder().encode(stores), encoding: .utf8)

    UserDefaults.standard.setValue(json, forKey: "grocery-stores")
  }
}

extension GroceryStoresClient: DependencyKey {
  public static var liveValue: GroceryStoresClient = .userDefaults
  public static var previewValue: GroceryStoresClient = .userDefaults
}

extension DependencyValues {
  public var groceryStoresClient: GroceryStoresClient {
    get {
      self[GroceryStoresClient.self]
    }
    set {
      self[GroceryStoresClient.self] = newValue
    }
  }
}
