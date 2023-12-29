import Dependencies
import Foundation
import IdentifiedCollections

public struct ShoppingTrip: Equatable, Identifiable {
	public var id = UUID()
	public var store: GroceryStore?
	public var groups: IdentifiedArrayOf<GroupedListItem>

	public var allItems: IdentifiedArrayOf<ListItem> {
		return groups.reduce([]) { partialResult, groupedListItem in
			var updatedResult = partialResult

			updatedResult.append(contentsOf: groupedListItem.items)

			return updatedResult
		}
	}

	public init(
		id: UUID? = nil,
		store: GroceryStore? = nil,
		groups: IdentifiedArrayOf<GroupedListItem>
	) {
		@Dependency(\.uuid) var uuid

		self.id = id ?? uuid()
		self.store = store
		self.groups = groups
	}
}
