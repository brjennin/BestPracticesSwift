import AVKit
import AVFoundation

protocol AudioBoxProtocol: class {
    init(file: AVAudioFile, engine: AudioEngineProtocol, player: AudioPlayerNodeProtocol, pitchShift: AVAudioUnitVarispeed, delays: [AudioDelayNodeProtocol], reverb: AVAudioUnitReverb)

    func start() throws
    func stop()
    func play(delay: Bool, reverb: Bool)
    func pitchShift(amount: Float)
}

class AudioBox: AudioBoxProtocol {
    static let reverbAmount: Float = 50.0
    
    private(set) var engine: AudioEngineProtocol!
    private(set) var player: AudioPlayerNodeProtocol!
    private(set) var pitchShift: AVAudioUnitVarispeed!
    private(set) var delays: [AudioDelayNodeProtocol]!
    private(set) var reverb: AVAudioUnitReverb!
    private(set) var file: AVAudioFile!

    required init(file: AVAudioFile, engine: AudioEngineProtocol, player: AudioPlayerNodeProtocol, pitchShift: AVAudioUnitVarispeed, delays: [AudioDelayNodeProtocol], reverb: AVAudioUnitReverb) {
        self.file = file
        self.engine = engine
        self.player = player
        self.pitchShift = pitchShift
        self.delays = delays
        self.reverb = reverb
    }

    func start() throws {
        engine.prepare()
        try engine.start()
    }

    func stop() {
        player.stop()
    }

    func play(delay: Bool, reverb: Bool) {
        for delayNode in delays {
            delayNode.bypass = !delay
        }
        if reverb {
            self.reverb.wetDryMix = AudioBox.reverbAmount
        } else {
            self.reverb.wetDryMix = 0
        }
        player.scheduleFile(file, at: nil, completionHandler: nil)
        player.play()
    }

    func pitchShift(amount: Float) {
        pitchShift.rate = amount
    }

}
