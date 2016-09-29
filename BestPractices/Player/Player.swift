import AVKit
import AVFoundation

protocol PlayerProtocol: class {
    func loadSong(filePath: String)

    func clearSong()

    func play(delay: Bool)
    
    func pitchShift(amount: Float)
}

class Player: PlayerProtocol {

    var engineBuilder: EngineBuilderProtocol! = EngineBuilder()
    var shiftTranslator: ShiftTranslatorProtocol! = ShiftTranslator()
    
    var playerNode: AudioPlayerNodeProtocol?
    var delayNodes: [AudioDelayNodeProtocol]?
    var engine: AudioEngineProtocol!
    var pitchShiftNode: AVAudioUnitVarispeed?
    var audioFile: AVAudioFile!

    func loadSong(filePath: String) {
        let url = URL(fileURLWithPath: filePath)
        let file = try? AVAudioFile.init(forReading: url)

        if let file = file {
            var audioPlayer: AudioPlayerNodeProtocol
            var audioEngine: AudioEngineProtocol
            var audioDelayNodes: [AudioDelayNodeProtocol]
            var audioShiftNode: AVAudioUnitVarispeed
            (audioPlayer, audioEngine, audioDelayNodes, audioShiftNode) = engineBuilder.buildEngine(audioFile: file)

            audioEngine.prepare()
            do {
                try audioEngine.start()
            } catch {
                return
            }

            playerNode = audioPlayer
            engine = audioEngine
            delayNodes = audioDelayNodes
            audioFile = file
            pitchShiftNode = audioShiftNode
        }
    }

    func clearSong() {
        if let playerNode = playerNode {
            playerNode.stop()
        }
        engine = nil
        playerNode = nil
        delayNodes = nil
        audioFile = nil
        pitchShiftNode = nil
    }

    func play(delay: Bool) {
        if let playerNode = playerNode {
            setDelayBypass(delayUnits: delayNodes!, bypass: !delay)
            playerNode.scheduleFile(audioFile, at: nil, completionHandler: nil)
            playerNode.play()
        }
    }
    
    func pitchShift(amount: Float) {
        pitchShiftNode?.rate = shiftTranslator.translateSlider(value: amount)
    }

    fileprivate func setDelayBypass(delayUnits: [AudioDelayNodeProtocol], bypass: Bool) {
        for unit in delayUnits {
            unit.bypass = bypass
        }
    }
}
