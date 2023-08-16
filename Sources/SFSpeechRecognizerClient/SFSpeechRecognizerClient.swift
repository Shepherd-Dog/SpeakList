import AVAudioEngineClient
import AVFAudio
import Combine
import Dependencies
import Speech

public struct SFSpeechRecognizerClient {
  public var listen: () -> AnyPublisher<String, Never>
  public var requestAccess: () -> Void
  public var stopListening: () throws -> Void
}

extension SFSpeechRecognizerClient: DependencyKey {
  public static var liveValue: Self {
    .live(audioEngineClient: .live())
  }

  public static var previewValue: Self {
    .live(audioEngineClient: .live())
  }
}

extension DependencyValues {
  public var speechRecognizerClient: SFSpeechRecognizerClient {
    get { self[SFSpeechRecognizerClient.self] }
    set { self[SFSpeechRecognizerClient.self] = newValue }
  }
}

extension SFSpeechRecognizerClient {

  public static func live(audioEngineClient: AVAudioEngineClient) -> SFSpeechRecognizerClient {
    let speechRecognizer = SFSpeechRecognizer()
    let subject = PassthroughSubject<String, Never>()

    return .init {
      let request = SFSpeechAudioBufferRecognitionRequest()
      request.shouldReportPartialResults = true
      request.requiresOnDeviceRecognition = true

      try! audioEngineClient.setup()
      audioEngineClient.installTap { buffer, _ in
        request.append(buffer)
      }
      audioEngineClient.prepare()
      try! audioEngineClient.start()

      speechRecognizer?.recognitionTask(
        with: request,
        resultHandler: { result, error in
          guard let result else {
            return
          }
          subject.send(result.bestTranscription.formattedString)
        }
      )
      
      return subject.eraseToAnyPublisher()
    } requestAccess: {
      SFSpeechRecognizer.requestAuthorization { status in
        switch status {
        case .notDetermined:
          break
        case .denied:
          break
        case .restricted:
          break
        case .authorized:
          break
        @unknown default:
          break
        }
      }
    } stopListening: {
      try audioEngineClient.stop()
    }
  }
}
