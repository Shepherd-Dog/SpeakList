import ComposableArchitecture
import Model
import PlanFeature
import SettingsFeature
import ShopFeature
import StoresFeature

public struct AppFeature: Reducer {
  public struct State: Equatable {
    public var listFeature: PlanFeature.State = .init()
    public var settingsFeature: SettingsFeature.State = .init()
    public var shopFeature: ShopFeature.State = .init(
      trips: IdentifiedArrayOf<ShoppingTrip>(
        uniqueElements: [
//          ListItem(name: "Bananas", checked: false),
//          ListItem(name: "Apples", checked: false),
//          ListItem(name: "Protein Powder", checked: false),
//          ListItem(name: "Peanut Butter", checked: false),
        ]
      )
    )
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
