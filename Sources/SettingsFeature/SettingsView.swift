import ComposableArchitecture
import SwiftUI

public struct SettingsView: View {
  var store: StoreOf<SettingsFeature>

  public init(store: StoreOf<SettingsFeature>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(store) {
      $0
    } content: { viewStore in
      Text("Insert settings here")
    }
    .navigationTitle("Settings")
  }
}
