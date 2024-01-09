import Dependencies
import DependenciesMacros
import Foundation
import IdentifiedCollections
import Model

@DependencyClient
public struct GroceryStoresClient {
	public var fetchGroceryStores: () async throws -> IdentifiedArrayOf<GroceryStore>
	public var save: (_ stores: IdentifiedArrayOf<GroceryStore>) async throws -> Void
}

extension GroceryStoresClient {
	static let userDefaults: Self = .init {
		let json = UserDefaults.standard.string(forKey: "grocery-stores")

		guard let data = json?.data(using: .utf8) else {
			return []
		}

		return try JSONDecoder().decode(IdentifiedArrayOf<GroceryStore>.self, from: data)
	} save: { stores in
		let json = String(data: try JSONEncoder().encode(stores), encoding: .utf8)

		UserDefaults.standard.setValue(json, forKey: "grocery-stores")
	}
}

extension GroceryStoresClient: DependencyKey {
	public static var liveValue: GroceryStoresClient = .userDefaults
	public static var previewValue: GroceryStoresClient = .mockNonStaticComputed
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

extension GroceryStoresClient {
	static var mockStoresCache:
		ActorIsolated<
			IdentifiedArrayOf<
				GroceryStore
			>
		> = .init(
			[
				GroceryStore.mockSprout,
				GroceryStore.mockNaturalGrocers,
				GroceryStore.mockKroger,
			]
		)

	public static let mock: Self = .init {
		await mockStoresCache.value
	} save: { stores in
		await mockStoresCache.setValue(stores)
	}

	public static let mockNonStatic: Self = {

		var mockStoresCache: IdentifiedArrayOf<GroceryStore> = .init(
			.init(uniqueElements: [
				GroceryStore(id: UUID(42), name: "ABCD"),
				GroceryStore(id: UUID(43), name: "EFGH"),
				GroceryStore(id: UUID(44), name: "JKLM"),
			]))

		return .init {
			mockStoresCache
		} save: { stores in
			mockStoresCache = stores
		}
	}()

	public static var mockNonStaticComputed: Self {

		var mockStoresCache: IdentifiedArrayOf<GroceryStore> = .init(
			.init(uniqueElements: [
				GroceryStore(id: UUID(42), name: "ABCD"),
				GroceryStore(id: UUID(43), name: "EFGH"),
				GroceryStore(id: UUID(44), name: "JKLM"),
			]))

		return .init {
			mockStoresCache
		} save: { stores in
			mockStoresCache = stores
		}
	}

}
