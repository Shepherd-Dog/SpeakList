import ComposableArchitecture
import SwiftUI

public struct FlowRunner {
	public static func run<State: Equatable, Action: Equatable>(
		type: String,
		store: Store<State, Action>,
		initialView: some View,
		initializationAction: FlowRunner.NamedAction<Action>,
		actions: [FlowRunner.NamedAction<Action>],
		configurations: [FlowRunner.Configuration],
		betweenActionsHandler: @MainActor @escaping (
			UIViewController, UIUserInterfaceStyle, String
		) -> Void
	) async throws {
		for configuration in configurations {
			try await run(
				type: type,
				store: store,
				initialView: initialView,
				initializationAction: initializationAction,
				actions: actions,
				configuration: configuration,
				betweenActionsHandler: betweenActionsHandler
			)
		}
	}

	private static func run<State: Equatable, Action: Equatable>(
		type: String,
		store: Store<State, Action>,
		initialView: some View,
		initializationAction: FlowRunner.NamedAction<Action>,
		actions: [FlowRunner.NamedAction<Action>],
		configuration: FlowRunner.Configuration,
		betweenActionsHandler: @MainActor @escaping (
			UIViewController, UIUserInterfaceStyle, String
		) -> Void
	) async throws {
		let view =
			initialView
			.environment(\.colorScheme, configuration.colorScheme)
			.environment(\.dynamicTypeSize, configuration.dynamicTypeSize)
			.environment(\.locale, configuration.locale)
			.environment(
				\.layoutDirection,
				LayoutDirection.from(
					Locale.Language(
						identifier: configuration.locale.identifier
					).characterDirection
				)
			)
			.transaction { $0.animation = nil }

		let hostingController = await UIHostingController(rootView: view)

		let uiUserInterfaceStyle: UIUserInterfaceStyle =
			configuration.colorScheme == .dark ? .dark : .light

		await betweenActionsHandler(
			hostingController,
			uiUserInterfaceStyle,
			"\(configuration.name) \(type): Throwaway"
		)

		// Wait for SwiftUI to settle
		try await Task.sleep(nanoseconds: NSEC_PER_MSEC * 1000)

		await betweenActionsHandler(
			hostingController,
			uiUserInterfaceStyle,
			"\(configuration.name) \(type): 01. \(initializationAction.name)"
		)

		let numberFormetter = NumberFormatter()
		numberFormetter.minimumIntegerDigits = 2

		for (index, action) in actions.enumerated() {
			_ = await MainActor.run {
				store.send(action.action)
			}
			guard let count = numberFormetter.string(from: index + 2 as NSNumber) else {
				XCTFail("Could not format number")
				continue
			}

			// Wait for SwiftUI to settle
			try await Task.sleep(nanoseconds: NSEC_PER_MSEC * 600)

			await betweenActionsHandler(
				hostingController,
				uiUserInterfaceStyle,
				"\(configuration.name) \(type): \(count). \(action.name)"
			)
		}

		// Wait a short bit between scenarios
		try await Task.sleep(nanoseconds: NSEC_PER_MSEC * 500)
	}

	public struct NamedAction<Action> {
		public let name: String
		public let action: Action

		public init(name: String, action: Action) {
			self.name = name
			self.action = action
		}
	}

	public struct Configuration {
		public var colorScheme: ColorScheme
		public var dynamicTypeSize: DynamicTypeSize
		public var locale: Locale
		public var name: String

		public init(
			colorScheme: ColorScheme = .light,
			dynamicTypeSize: DynamicTypeSize = .large,
			locale: Locale = Locale(identifier: "en-US"),
			name: String
		) {
			self.colorScheme = colorScheme
			self.dynamicTypeSize = dynamicTypeSize
			self.locale = locale
			self.name = name
		}
	}
}

extension LayoutDirection {
	fileprivate static func from(
		_ localeLanguageDirection: Locale.LanguageDirection
	) -> Self {
		switch localeLanguageDirection {
		case .unknown:
			return .leftToRight
		case .leftToRight:
			return .leftToRight
		case .rightToLeft:
			return .rightToLeft
		case .topToBottom:
			fatalError("Top to bottom character directions not supported")
		case .bottomToTop:
			fatalError("Bottom to top character directions not supported")
		@unknown default:
			fatalError("Unknown language direction")
		}
	}
}
