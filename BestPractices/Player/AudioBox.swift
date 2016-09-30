import AVKit
import AVFoundation

protocol AudioBoxProtocol: class {
    init(file: AVAudioFile, engine: AudioEngineProtocol, player: AudioPlayerNodeProtocol, pitchShift: AVAudioUnitVarispeed, delays: [AudioDelayNodeProtocol], reverb: AVAudioUnitReverb, eq: AVAudioUnitEQ)

    func start() throws
    func stop()
    func play(delay: Bool, reverb: Bool)
    func pitchShift(amount: Float)
}

class AudioBox: AudioBoxProtocol {
    static let reverbAmount: Float = 50.0
    static let reverbGain: Float = 4.0

    private(set) var engine: AudioEngineProtocol!
    private(set) var player: AudioPlayerNodeProtocol!
    private(set) var pitchShift: AVAudioUnitVarispeed!
    private(set) var delays: [AudioDelayNodeProtocol]!
    private(set) var reverb: AVAudioUnitReverb!
    private(set) var eq: AVAudioUnitEQ!
    private(set) var file: AVAudioFile!

    required init(file: AVAudioFile, engine: AudioEngineProtocol, player: AudioPlayerNodeProtocol, pitchShift: AVAudioUnitVarispeed, delays: [AudioDelayNodeProtocol], reverb: AVAudioUnitReverb, eq: AVAudioUnitEQ) {
        self.file = file
        self.engine = engine
        self.player = player
        self.pitchShift = pitchShift
        self.delays = delays
        self.reverb = reverb
        self.eq = eq
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
            self.eq.globalGain = AudioBox.reverbGain
        } else {
            self.reverb.wetDryMix = 0
            self.eq.globalGain = 0
        }
        player.scheduleFile(file, at: nil, completionHandler: nil)
        player.play()
    }

    func pitchShift(amount: Float) {
        pitchShift.rate = amount
    }

}
