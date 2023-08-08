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
          StoresView(
            store: store.scope(
              state: \.storesFeature,
              action: AppFeature.Action.storesFeature
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
    var storesFeature: StoresFeature.State = .init()
  }

  enum Action: Equatable {
    case listFeature(PlanFeature.Action)
    case shopFeature(ShopFeature.Action)
    case storesFeature(StoresFeature.Action)
  }

  var body: some ReducerOf<Self> {
    Scope(
      state: \.listFeature,
      action: /Action.listFeature
    ) {
      PlanFeature()
    }
    Scope(
      state: \.shopFeature,
      action: /Action.shopFeature
    ) {
      ShopFeature()
    }
    Scope(
      state: \.storesFeature,
      action: /Action.storesFeature
    ) {
      StoresFeature()
    }
  }
}
