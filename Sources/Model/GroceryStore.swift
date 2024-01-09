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
			.unknown,
		]
	)

	public init(
		id: UUID? = nil,
		name: String
	) {
		@Dependency(\.uuid) var uuid
		self.id = id ?? uuid()
		self.name = name
	}
}

//extension GroceryStore {
//  static let none: Self = .init(id: UUID(0), name: "")
//}

extension GroceryStore {
	public static let mockSprout = Self(
		id: UUID(42),
		name: "Sprout"
	)

	public static let mockSprouts = Self(
		id: UUID(42),
		name: "Sprouts"
	)

	public static let mockNaturalGrocers = Self(
		id: UUID(43),
		name: "Natural Grocers"
	)

	public static let mockKroger = Self(
		id: UUID(44),
		name: "Kroger"
	)
}

extension IdentifiedArray where ID == UUID, Element == GroceryStore {
	public static var mocks: Self {
		[
			.mockSprouts,
			.mockNaturalGrocers,
			.mockKroger,
		]
	}

	public static var mocksWithTypoInSprouts: Self {
		[
			.mockSprout,
			.mockNaturalGrocers,
			.mockKroger,
		]
	}
}
