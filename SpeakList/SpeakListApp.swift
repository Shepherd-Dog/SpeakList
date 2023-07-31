import ComposableArchitecture
import SwiftUI

@main
struct SpeakListApp: App {
  var store: StoreOf<AppFeature> = .init(
    initialState: .init()
  ) {
    AppFeature()
  }

  var body: some Scene {
    WindowGroup {
      NavigationStack {
        TabView {
          ShopView(
            store: store.scope(
              state: \.listFeature,
              action: AppFeature.Action.listFeature
            )
          )
          .tabItem { Text("Plan") }
        }
        TabView {
          ShopView(
            store: store.scope(
              state: \.listFeature,
              action: AppFeature.Action.listFeature
            )
          )
          .tabItem { Text("Shop") }
        }
        TabView {
          ShopView(
            store: store.scope(
              state: \.listFeature,
              action: AppFeature.Action.listFeature
            )
          )
          .tabItem { Text("Settings") }
        }
      }
    }
  }
}

struct AppFeature: Reducer {
  struct State: Equatable {
    var listFeature: ShopFeature.State = .init(
      items: IdentifiedArrayOf<ListItem>(
        uniqueElements: [
          ListItem(name: "Bananas", checked: false),
          ListItem(name: "Apples", checked: false),
          ListItem(name: "Protein Powder", checked: false),
          ListItem(name: "Peanut Butter", checked: false),
        ]
      )
    )
  }

  enum Action: Equatable {
    case listFeature(ShopFeature.Action)
  }

  var body: some ReducerOf<Self> {
    Scope(
      state: \.listFeature,
      action: /Action.listFeature
    ) {
      ShopFeature()
    }
  }
}
