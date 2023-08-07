struct GroceryStore: Equatable, Identifiable {
  var id: String {
    name
  }
  var name: String
}
