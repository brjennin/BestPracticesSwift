import AVKit
import AVFoundation

protocol AudioBoxProtocol: class {
    init(file: AVAudioFile, engine: AudioEngineProtocol, player: AudioPlayerNodeProtocol, pitchShift: AVAudioUnitVarispeed, delays: [AudioDelayNodeProtocol])

    func start() throws
    func stop()
    func play(delay: Bool)
    func pitchShift(amount: Float)
}

class AudioBox: AudioBoxProtocol {
    private(set) var engine: AudioEngineProtocol!
    private(set) var player: AudioPlayerNodeProtocol!
    private(set) var pitchShift: AVAudioUnitVarispeed!
    private(set) var delays: [AudioDelayNodeProtocol]!
    private(set) var file: AVAudioFile!

    required init(file: AVAudioFile, engine: AudioEngineProtocol, player: AudioPlayerNodeProtocol, pitchShift: AVAudioUnitVarispeed, delays: [AudioDelayNodeProtocol]) {
        self.file = file
        self.engine = engine
        self.player = player
        self.pitchShift = pitchShift
        self.delays = delays
    }

    func start() throws {
        engine.prepare()
        try engine.start()
    }

    func stop() {
        player.stop()
    }

    func play(delay: Bool) {
        for delayNode in delays {
            delayNode.bypass = !delay
        }
        player.scheduleFile(file, at: nil, completionHandler: nil)
        player.play()
    }

    func pitchShift(amount: Float) {
        pitchShift.rate = amount
    }

}
