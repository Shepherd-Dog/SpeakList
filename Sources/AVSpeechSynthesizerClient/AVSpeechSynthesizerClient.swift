import AVFAudio
import Combine
import Dependencies

public struct AVSpeechSynthesizerClient {
  public var didFinishPublisher: () -> AnyPublisher<Bool, Never>
  public var speak: (String) -> Void
}

extension AVSpeechSynthesizerClient: DependencyKey {
  public static var liveValue: Self {
    .englishUS
  }

  public static var previewValue: Self {
    .englishUS
  }
}

extension DependencyValues {
  public var speechSynthesizerClient: AVSpeechSynthesizerClient {
    get { self[AVSpeechSynthesizerClient.self] }
    set { self[AVSpeechSynthesizerClient.self] = newValue }
  }
}

extension AVSpeechSynthesizerClient {
  class Delegate: NSObject, AVSpeechSynthesizerDelegate {
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
      AVSpeechSynthesizerClient.subject.send(true)
    }
  }

  static var speechSynthesizer = AVSpeechSynthesizer()
  static var delegate: Delegate = Delegate()
  static let subject = PassthroughSubject<Bool, Never>()

  public static let englishUS = AVSpeechSynthesizerClient {
    subject.eraseToAnyPublisher()
  } speak: { input in
    speechSynthesizer.usesApplicationAudioSession = false
    speechSynthesizer.delegate = delegate

    let utterance = AVSpeechUtterance(string: input)

    utterance.rate = 0.6
    utterance.voice = AVSpeechSynthesisVoice(language: "en_US")

    speechSynthesizer.speak(utterance)
  }
}
