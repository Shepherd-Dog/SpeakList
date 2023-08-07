struct GroceryStoreLocation: Equatable, Identifiable {
  var id: String {
    store.name
  }
  var location: Location
  var store: GroceryStore
}
