import ComposableArchitecture
import PlanFeature
import SettingsFeature
import ShopFeature
import StoresFeature
import SwiftUI

public struct AppView: View {
  var store: StoreOf<AppFeature>

  public init(store: StoreOf<AppFeature>) {
    self.store = store
  }

  public var body: some View {
    TabView {
      NavigationView {
        PlanView(
          store: store.scope(
            state: \.listFeature,
            action: \.listFeature
          )
        )
      }
      .tabItem { Label("Plan", systemImage: "list.clipboard") }
      NavigationStack {
        ShopView(
          store: store.scope(
            state: \.shopFeature,
            action: \.shopFeature
          )
        )
      }
      .tabItem { Label("Shop", systemImage: "cart") }
      NavigationStack {
        StoresView(
          store: store.scope(
            state: \.storesFeature,
            action: \.storesFeature
          )
        )
      }
      .tabItem { Label("Stores", systemImage: "house") }
      NavigationStack {
        SettingsView(
          store: store.scope(
            state: \.settingsFeature,
            action: \.settingsFeature
          )
        )
      }
      .tabItem { Label("Settings", systemImage: "gear") }
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
