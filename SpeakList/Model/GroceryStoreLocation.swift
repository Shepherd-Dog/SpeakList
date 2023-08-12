struct GroceryStoreLocation: Codable, Equatable, Hashable, Identifiable {
  var id: String {
    store.name
  }
  var location: Location
  var store: GroceryStore
}
