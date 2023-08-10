import ComposableArchitecture

struct GroupedListItem: Identifiable {
  var id: String {
    name
  }
  var name: String
  var items: IdentifiedArrayOf<ListItem>
}
