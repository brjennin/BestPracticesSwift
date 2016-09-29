import AVKit
import AVFoundation

protocol AudioPlayerNodeProtocol: class {
    func scheduleFile(_ file: AVAudioFile, at when: AVAudioTime?, completionHandler: AVFoundation.AVAudioNodeCompletionHandler?)
    func stop()
    func play()
}

protocol AudioEngineProtocol: class {
    func prepare()
    func start() throws
}

protocol AudioDelayNodeProtocol: class {
    var bypass: Bool { get set }
}

extension AVAudioPlayerNode: AudioPlayerNodeProtocol {}
extension AVAudioEngine: AudioEngineProtocol {}
extension AVAudioUnitDelay: AudioDelayNodeProtocol {}
