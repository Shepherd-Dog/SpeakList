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


enum ReturnValue: TheReturnType {
 case meow
}

class Provider: InstanceProvider {
   typealias ConcreteReturnType = ReturnValue

  var value: ConcreteReturnType { .meow } // Compiler forces this to be public,
                                         // which means ReturnValue must be public as well
}
