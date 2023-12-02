import ComposableArchitecture
import Model
import PlanFeature
import SettingsFeature
import ShopFeature
import StoresFeature

@Reducer
public struct AppFeature {
  @ObservableState
  public struct State: Equatable {
    public var listFeature: PlanFeature.State = .init()
    public var settingsFeature: SettingsFeature.State = .init()
    public var shopFeature: ShopFeature.State = .init()
    public var storesFeature: StoresFeature.State = .init()

    public init(
      listFeature: PlanFeature.State = .init(),
      settingsFeature: SettingsFeature.State = .init(),
      shopFeature: ShopFeature.State = .init(),
      storesFeature: StoresFeature.State = .init()
    ) {
      self.listFeature = listFeature
      self.settingsFeature = settingsFeature
      self.shopFeature = shopFeature
      self.storesFeature = storesFeature
    }
  }

  public enum Action: Equatable {
    case listFeature(PlanFeature.Action)
    case settingsFeature(SettingsFeature.Action)
    case shopFeature(ShopFeature.Action)
    case storesFeature(StoresFeature.Action)
  }

  public init() {}

  public var body: some ReducerOf<Self> {
    Scope(
      state: \.listFeature,
      action: \.listFeature
    ) {
      PlanFeature()
    }
    Scope(
      state: \.settingsFeature,
      action: \.settingsFeature
    ) {
      SettingsFeature()
    }
    Scope(
      state: \.shopFeature,
      action: \.shopFeature
    ) {
      ShopFeature()
    }
    Scope(
      state: \.storesFeature,
      action: \.storesFeature
    ) {
      StoresFeature()
    }
  }
}
