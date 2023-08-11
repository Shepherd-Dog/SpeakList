import ComposableArchitecture

struct ShopFeature: Reducer {
  struct State: Equatable {
    var items: IdentifiedArrayOf<ListItem> = []
  }

  enum Action: Equatable {
    case didReceiveShoppingList(IdentifiedArrayOf<ListItem>)
    case didReceiveSpeechRecognition(String)
    case didTapListItem(ListItem)
    case didTapReadButton
    case onAppear
    case startListening
  }

  @Dependency(\.mainQueue) var mainQueue
  @Dependency(\.shoppingListClient) var shoppingListClient
  @Dependency(\.speechSynthesizerClient) var speechSynthesizerClient
  @Dependency(\.speechRecognizerClient) var speechRecognizerClient

  var body: some ReducerOf<Self> {
    Reduce { state, action in
      enum Listening: Hashable {
        case start
      }
      switch action {
      case let .didReceiveShoppingList(items):
        state.items = items

        return .none
      case let .didReceiveSpeechRecognition(speech):
        guard let item = state.items.first(where: { $0.checked == false }) else {
          // TODO: Error
          return .none
        }
        print("Received speech: \(speech)")
        if speech.lowercased().contains("check") {
          state.items[id: item.id]?.checked = true
          // TODO: Need audio confirmation
          try? speechRecognizerClient.stopListening()

          return .merge(
            Effect.cancel(id: Listening.start),
            readNextItem(state: &state)
          )
        }

        return .none
      case let .didTapListItem(item):
        state.items[id: item.id]?.checked = !item.checked

        return .none
      case .didTapReadButton:
        return readNextItem(state: &state)
      case .onAppear:
        speechRecognizerClient.requestAccess()
        speechSynthesizerClient.speak("")

        return .run { send in
          let list = try await shoppingListClient.fetchShoppingList()

          await send(.didReceiveShoppingList(list))
        }
      case .startListening:
        return .publisher {
          speechRecognizerClient
            .listen()
            .map {
              .didReceiveSpeechRecognition($0)
            }
        }.cancellable(
          id: Listening.start,
          cancelInFlight: true
        )
      }
    }
  }

  private func readNextItem(state: inout State) -> Effect<Action> {
    enum Speaking: Hashable {
      case finish
    }
    guard let item = state.items.first(where: { $0.checked == false }) else {
      // TODO: Error
      return .none
    }

    speechSynthesizerClient.speak("\(item.quantity) \(item.name)")

    return .publisher {
      speechSynthesizerClient
        .didFinishPublisher()
        .map { _ in
          .startListening
        }
    }.cancellable(
      id: Speaking.finish,
      cancelInFlight: true
    )
  }
}
