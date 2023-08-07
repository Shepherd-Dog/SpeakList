import ComposableArchitecture

struct StoresFeature: Reducer {
  struct State: Equatable {
    var stores: IdentifiedArrayOf<GroceryStore> = []
  }

  enum Action: Equatable {
  }

  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      }
    }
  }
}
