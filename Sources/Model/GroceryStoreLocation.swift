import Dependencies
import Foundation

public struct GroceryStoreLocation: Codable, Equatable, Hashable, Identifiable {
	public var id = UUID()
	public var location: Location
	public var storeID: GroceryStore.ID?

	public init(
		id: UUID? = nil, location: Location,
		storeID: GroceryStore.ID? = nil
	) {
		@Dependency(\.uuid) var uuid

		self.id = id ?? uuid()
		self.location = location
		self.storeID = storeID
	}

	public static let unknown: Self = .init(
		location: .unknown
	)
}
