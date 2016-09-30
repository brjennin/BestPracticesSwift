import AVKit
import AVFoundation
@testable import BestPractices

class MockAudioBox: AudioBoxProtocol {
    required init(file: AVAudioFile, engine: AudioEngineProtocol, player: AudioPlayerNodeProtocol, pitchShift: AVAudioUnitVarispeed, delays: [AudioDelayNodeProtocol], reverb: AVAudioUnitReverb) {
    }

    var calledStart = false
    var startShouldThrow: Bool! = false
    func start() throws {
        calledStart = true
        if startShouldThrow! {
            throw NSError(domain: "domain", code: 3423, userInfo: nil)
        }
    }

    var calledStop = false
    func stop() {
        calledStop = true
    }

    var calledPlay = false
    var capturedDelay: Bool?
    var capturedReverb: Bool?
    func play(delay: Bool, reverb: Bool) {
        calledPlay = true
        capturedDelay = delay
        capturedReverb = reverb
    }

    var calledPitchShift = false
    var capturedPitchShiftAmount: Float?
    func pitchShift(amount: Float) {
        calledPitchShift = true
        capturedPitchShiftAmount = amount
    }
}
