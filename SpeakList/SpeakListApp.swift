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
      AppView(store: store)
    }
  }
}

struct AppView: View {
  var store: StoreOf<AppFeature>

  var body: some View {
    TabView {
      NavigationStack {
        PlanView(
          store: store.scope(
            state: \.listFeature,
            action: AppFeature.Action.listFeature
          )
        )
      }
      .tabItem { Label("Plan", systemImage: "list.clipboard") }
      NavigationStack {
        ShopView(
          store: store.scope(
            state: \.shopFeature,
            action: AppFeature.Action.shopFeature
          )
        )
      }
      .tabItem { Label("Shop", systemImage: "cart") }
      NavigationStack {
        StoresView(
          store: store.scope(
            state: \.storesFeature,
            action: AppFeature.Action.storesFeature
          )
        )
      }
      .tabItem { Label("Stores", systemImage: "house") }
      NavigationStack {
        SettingsView(
          store: store.scope(
            state: \.settingsFeature,
            action: AppFeature.Action.settingsFeature
          )
        )
      }
      .tabItem { Label("Settings", systemImage: "gear") }
    }
  }
}

struct AppFeature: Reducer {
  struct State: Equatable {
    var listFeature: PlanFeature.State = .init()
    var settingsFeature: SettingsFeature.State = .init()
    var shopFeature: ShopFeature.State = .init(
      trips: IdentifiedArrayOf<ShoppingTrip>(
        uniqueElements: [
//          ListItem(name: "Bananas", checked: false),
//          ListItem(name: "Apples", checked: false),
//          ListItem(name: "Protein Powder", checked: false),
//          ListItem(name: "Peanut Butter", checked: false),
        ]
      )
    )
    var storesFeature: StoresFeature.State = .init()
  }

  enum Action: Equatable {
    case listFeature(PlanFeature.Action)
    case settingsFeature(SettingsFeature.Action)
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
      state: \.settingsFeature,
      action: /Action.settingsFeature
    ) {
      SettingsFeature()
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

#Preview {
  AppView(
    store: .init(
      initialState: .init()) {
      AppFeature()
    }
  )
}
