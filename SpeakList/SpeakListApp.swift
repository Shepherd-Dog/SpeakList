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
      TabView {
        NavigationStack {
          PlanView(
            store: store.scope(
              state: \.listFeature,
              action: AppFeature.Action.listFeature
            )
          )
        }
        .tabItem { Text("Plan") }
        NavigationStack {
          ShopView(
            store: store.scope(
              state: \.shopFeature,
              action: AppFeature.Action.shopFeature
            )
          )
        }
        .tabItem { Text("Shop") }
        NavigationStack {
          PlanView(
            store: store.scope(
              state: \.listFeature,
              action: AppFeature.Action.listFeature
            )
          )
        }
        .tabItem { Text("Stores") }
        NavigationStack {
          PlanView(
            store: store.scope(
              state: \.listFeature,
              action: AppFeature.Action.listFeature
            )
          )
        }
        .tabItem { Text("Settings") }
      }
    }
  }
}

struct AppFeature: Reducer {
  struct State: Equatable {
    var listFeature: PlanFeature.State = .init()
    var shopFeature: ShopFeature.State = .init(
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
    case listFeature(PlanFeature.Action)
    case shopFeature(ShopFeature.Action)
  }

  var body: some ReducerOf<Self> {
    Scope(
      state: \.shopFeature,
      action: /Action.shopFeature
    ) {
      ShopFeature()
    }
    Scope(
      state: \.listFeature,
      action: /Action.listFeature
    ) {
      PlanFeature()
    }
  }
}
