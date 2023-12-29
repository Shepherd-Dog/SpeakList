import IdentifiedCollections

public struct GroupedListItem: Equatable, Identifiable {
	public var id: String {
		name
	}
	public var name: String
	public var items: IdentifiedArrayOf<ListItem>

	public init(name: String, items: IdentifiedArrayOf<ListItem>) {
		self.name = name
		self.items = items
	}
}
