import Dependencies
import AVFAudio

public struct AVAudioEngineClient {
  var installTap: (@escaping (AVAudioPCMBuffer, AVAudioTime) -> Void) -> Void
  var prepare: () -> Void
  var setup: () throws -> Void
  var start: () throws -> Void
  var stop: () throws -> Void
}

extension AVAudioEngineClient: DependencyKey {
  public static var liveValue: Self {
    .live()
  }

  public static var previewValue: Self {
    .live()
  }
}

extension DependencyValues {
  public var audioEngineClient: AVAudioEngineClient {
    get { self[AVAudioEngineClient.self] }
    set { self[AVAudioEngineClient.self] = newValue }
  }
}

extension AVAudioEngineClient {
//  static
  
  public static func live() -> AVAudioEngineClient {
    let audioEngine = AVAudioEngine()

    return .init { block in
      let recordingFormat = audioEngine.inputNode.outputFormat(forBus: 0)

      audioEngine.inputNode.installTap(
        onBus: 0,
        bufferSize: 1024,
        format: recordingFormat
      ) { buffer, time in
        block(buffer, time)
      }
    } prepare: {
      audioEngine.prepare()
    } setup: {
      let audioSession = AVAudioSession.sharedInstance()
      try! audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
      try! audioSession.setActive(true, options: .notifyOthersOnDeactivation)
    } start: {
      try! audioEngine.start()
    } stop: {
      audioEngine.inputNode.removeTap(onBus: 0)
      audioEngine.stop()
      let audioSession = AVAudioSession.sharedInstance()
      try! audioSession.setActive(false)
    }
  }
}
