// swift-tools-version:5.9
import PackageDescription

let package = Package(
  name: "SpeakListApp",
  platforms: [
    .iOS(.v16),
  ],
  products: [
    .library(
      name: "AppFeature",
      targets: ["AppFeature"]
    ),
    .library(
      name: "AVAudioEngineClient",
      targets: ["AVAudioEngineClient"]
    ),
    .library(
      name: "AVSpeechSynthesizerClient",
      targets: ["AVSpeechSynthesizerClient"]
    ),
    .library(
      name: "GroceryStoresClient",
      targets: ["GroceryStoresClient"]
    ),
    .library(
      name: "SFSpeechRecognizerClient",
      targets: ["SFSpeechRecognizerClient"]
    ),
    .library(
      name: "ShoppingListClient",
      targets: ["ShoppingListClient"]
    ),
    .library(
      name: "DesignSystem",
      targets: ["DesignSystem"]
    ),
    .library(
      name: "ItemFormFeature",
      targets: ["ItemFormFeature"]
    ),
    .library(
      name: "PlanFeature",
      targets: ["PlanFeature"]
    ),
    .library(
      name: "SettingsFeature",
      targets: ["SettingsFeature"]
    ),
    .library(
      name: "ShopFeature",
      targets: ["ShopFeature"]
    ),
    .library(
      name: "ShoppingTripFeature",
      targets: ["ShoppingTripFeature"]
    ),
    .library(
      name: "StoresFeature",
      targets: ["StoresFeature"]
    ),
    .library(
      name: "Model",
      targets: ["Model"]
    ),
  ],
  dependencies: [
//    .package(
//      url: "https://github.com/cashapp/AccessibilitySnapshot.git",
//      from: "0.4.1"
//    ),
    .package(
      url: "https://github.com/DavidBrunow/AccessibilitySnapshot.git",
      branch: "bugfix/navigationStackSortOrder"
    ),
    .package(
      url: "https://github.com/pointfreeco/swift-composable-architecture",
      from: "1.1.0"
//      branch: "observation-beta"
    ),
    .package(url: "https://github.com/pointfreeco/swift-dependencies", from: "1.1.0"),
    .package(url: "https://github.com/pointfreeco/swift-snapshot-testing", from: "1.10.0"),
  ],
  targets: [
    .target(
      name: "AppFeature",
      dependencies: [
        "AVAudioEngineClient",
        "AVSpeechSynthesizerClient",
        "GroceryStoresClient",
        "SFSpeechRecognizerClient",
        "ShoppingListClient",
        "ItemFormFeature",
        "PlanFeature",
        "SettingsFeature",
        "ShopFeature",
        "ShoppingTripFeature",
        "StoresFeature",
        "DesignSystem",
        "Model",
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
      ]
    ),
    .target(
      name: "AVAudioEngineClient",
      dependencies: [
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
        .product(name: "DependenciesMacros", package: "swift-dependencies"),
      ]
    ),
    .target(
      name: "AVSpeechSynthesizerClient",
      dependencies: [
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
        .product(name: "DependenciesMacros", package: "swift-dependencies"),
      ]
    ),
    .target(
      name: "GroceryStoresClient",
      dependencies: [
        "Model",
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
        .product(name: "DependenciesMacros", package: "swift-dependencies"),
      ]
    ),
    .target(
      name: "SFSpeechRecognizerClient",
      dependencies: [
        "AVAudioEngineClient",
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
        .product(name: "DependenciesMacros", package: "swift-dependencies"),
      ]
    ),
    .target(
      name: "ShoppingListClient",
      dependencies: [
        "Model",
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
        .product(name: "DependenciesMacros", package: "swift-dependencies"),
      ]
    ),
    .target(
      name: "DesignSystem",
      dependencies: [
      ]
    ),
    .target(
      name: "ItemFormFeature",
      dependencies: [
        "Model",
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
      ]
    ),
    .target(
      name: "PlanFeature",
      dependencies: [
        "GroceryStoresClient",
        "ItemFormFeature",
        "Model",
        "ShoppingListClient",
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
      ]
    ),
    .testTarget(
      name: "PlanFeatureTests",
      dependencies: [
        "GroceryStoresClient",
        "ItemFormFeature",
        "Model",
        "PlanFeature",
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
      ]
    ),
    .target(
      name: "SettingsFeature",
      dependencies: [
        "Model",
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
      ]
    ),
    .testTarget(
      name: "SettingsFeatureTests",
      dependencies: [
        "SettingsFeature",
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
      ]
    ),
    .target(
      name: "ShopFeature",
      dependencies: [
        "GroceryStoresClient",
        "Model",
        "ShoppingListClient",
        "ShoppingTripFeature",
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
      ]
    ),
    .testTarget(
      name: "ShopFeatureTests",
      dependencies: [
        "ShopFeature",
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
      ]
    ),
    .target(
      name: "ShoppingTripFeature",
      dependencies: [
        "Model",
        "AVSpeechSynthesizerClient",
        "SFSpeechRecognizerClient",
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
      ]
    ),
    .testTarget(
      name: "NonHostedSnapshotTests",
      dependencies: [
        "AppFeature",
        "DesignSystem",
        "Model",
        "PlanFeature",
        .product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
        .product(name: "AccessibilitySnapshot", package: "AccessibilitySnapshot"),
      ]
    ),
    .target(
      name: "StoresFeature",
      dependencies: [
        "GroceryStoresClient",
        "Model",
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
      ]
    ),
    .testTarget(
      name: "StoresFeatureTests",
      dependencies: [
        "StoresFeature",
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
      ]
    ),
    .target(
      name: "Model",
      dependencies: [
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
      ]
    ),
  ]
)

