import ComposableArchitecture

struct ShoppingTripFeature: Reducer {
  struct State: Equatable {
    var trip: ShoppingTrip
  }

  enum Action: Equatable {
    case didReceiveSpeechRecognition(String)
    case didTapItem(ListItem)
    case didTapReadButton
    case startListening
    case onAppear
  }

  @Dependency(\.speechSynthesizerClient) var speechSynthesizerClient
  @Dependency(\.speechRecognizerClient) var speechRecognizerClient
  
  private enum CancelID {
    case listening
  }

  var body: some ReducerOf<Self> {

    Reduce { state, action in
      switch action {
      case let .didReceiveSpeechRecognition(speech):
        guard let item = state.trip.allItems.first(where: { $0.checked == false }) else {
          // TODO: Error
          return .none
        }

        if speech.lowercased().contains("check") {
          state.trip.groups[id: item.preferredStoreLocation.location.name]?.items[id: item.id]?.checked = true
          // TODO: Need audio confirmation
          try? speechRecognizerClient.stopListening()

          return .merge(
            Effect.cancel(id: CancelID.listening),
            readNextItem(state: &state)
          )
        }

        return .none
      case let .didTapItem(item):
        state.trip.groups[id: item.preferredStoreLocation.location.name]?.items[id: item.id]?.checked.toggle()

        return .none
      case .didTapReadButton:
        return readNextItem(state: &state)
      case .onAppear:
        speechRecognizerClient.requestAccess()
        speechSynthesizerClient.speak("")

        return .none
      case .startListening:
        return .publisher {
          speechRecognizerClient
            .listen()
            .map {
              .didReceiveSpeechRecognition($0)
            }
        }.cancellable(
          id: CancelID.listening,
          cancelInFlight: true
        )
      }
    }
  }

  private func readNextItem(state: inout State) -> Effect<Action> {
    enum CancelID: Hashable {
      case speaking
    }
    guard let item = state.trip.allItems.first(where: { $0.checked == false }) else {
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
      id: CancelID.speaking,
      cancelInFlight: true
    )
  }
}
