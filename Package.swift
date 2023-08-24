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
    .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "1.1.0"),
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
        "DesignSystem",
        "ItemFormFeature",
        "PlanFeature",
        "SettingsFeature",
        "ShopFeature",
        "ShoppingTripFeature",
        "StoresFeature",
        "Model",
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
      ]
    ),
    .target(
      name: "AVAudioEngineClient",
      dependencies: [
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
      ]
    ),
    .target(
      name: "AVSpeechSynthesizerClient",
      dependencies: [
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
      ]
    ),
    .target(
      name: "GroceryStoresClient",
      dependencies: [
        "Model",
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
      ]
    ),
    .target(
      name: "SFSpeechRecognizerClient",
      dependencies: [
        "AVAudioEngineClient",
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
      ]
    ),
    .target(
      name: "ShoppingListClient",
      dependencies: [
        "Model",
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
      ]
    ),
    .target(
      name: "DesignSystem",
      dependencies: [
      ]
    ),
    .testTarget(
      name: "SnapshotTests",
      dependencies: [
        "DesignSystem",
        .product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
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
        "ItemFormFeature",
        "Model",
        "ShoppingListClient",
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
      ]
    ),
//    .testTarget(
//      name: "PlanFeatureTests",
//      dependencies: [
//        "PlanFeature",
//        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
//      ]
//    ),
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

