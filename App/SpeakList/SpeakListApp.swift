import AppFeature
import ComposableArchitecture
import PlanFeature
import SettingsFeature
import ShopFeature
import StoresFeature
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

#Preview {
  AppView(
    store: .init(
      initialState: .init()) {
      AppFeature()
    }
  )
}
