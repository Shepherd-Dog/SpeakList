import ComposableArchitecture
import SwiftUI

struct SettingsView: View {
  var store: StoreOf<SettingsFeature>

  var body: some View {
    WithViewStore(store) {
      $0
    } content: { viewStore in
      Text("Insert settings here")
    }
    .navigationTitle("Settings")
  }
}
