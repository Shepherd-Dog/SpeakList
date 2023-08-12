import ComposableArchitecture

struct GroupedListItem: Equatable, Identifiable {
  var id: String {
    name
  }
  var name: String
  var items: IdentifiedArrayOf<ListItem>
}
